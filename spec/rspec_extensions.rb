require "ostruct"
def ostruct(*args)
  OpenStruct.new(*args)
end

def be_authorization_denied
  redirect_to("/403")
end

module RSpec::Rails::ControllerExampleGroup
  def params_from_url(method, url)
    ensure_that_routes_are_loaded
    @request.env['REQUEST_METHOD'] = method.to_s.upcase

    uri = URI.parse(url)
    @request.env["HTTPS"] = uri.scheme == "https" ? "on" : nil
    @request.host = uri.host
    @request.request_uri = uri.path.empty? ? "/" : uri.path

    ActionController::Routing::Routes.recognize(@request)
    @request.symbolized_path_parameters
  end

  def fake_login
    @current_user ||= create_user
    controller.stub!(:logged_in?).and_return(true)
    controller.stub!(:current_user).and_return(@current_user)
    session[:user] = @current_user
  end

  def disable_authorization
    controller.methods.grep(/^restriction_[0-9]+$/).map(&:to_sym).each do |restriction|
      controller.stub!(restriction).and_return(true)
    end
  end

  def get_with_ssl(*args)
    request.env['HTTP_X_FORWARDED_PROTO'] = 'https'
    get *args
    request.env.delete('HTTP_X_FORWARDED_PROTO')
  end

  def xhr_with_ssl(*args)
    request.env['HTTP_X_FORWARDED_PROTO'] = 'https'
    xhr *args
    request.env.delete('HTTP_X_FORWARDED_PROTO')
  end

  def post_with_ssl(*args)
    @request.env['HTTP_X_FORWARDED_PROTO'] = 'https'
    post *args
    @request.env.delete('HTTP_X_FORWARDED_PROTO')
  end

  def http_url(path)
    "http://" + request.host + path
  end

  def https_url(path)
    "https://" + request.host + path
  end
end

module ExampleHelpers
  def setup_mailer
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => "utf-8" }
    @expected.mime_version = '1.0'
  end

  def read_fixture(mailer, action)
    fixture_path = "#{File.dirname(__FILE__)}/fixtures/#{mailer}_mailer/#{action}"
    IO.readlines(fixture_path)
  rescue Errno::ENOENT => e
    raise "Could not find fixture in #{fixture_path}"
  end

  private :read_fixture
end

ActionController::TestRequest.class_eval do
  def query_string
    if uri = @env['REQUEST_URI']
      parts = uri.split('?')
      parts.shift
      parts.join('?')
    else
      @env['QUERY_STRING'] || ''
    end
  end
end

# Formats a given Time object into the Rails form fields generated by a datetime_select
def datetime_form_params(time = Time.now, prefix = 'datetime')
  options = {}
  {1 => time.year, 2 => time.month, 3 => time.day, 4 => time.hour, 5 => time.min}.each {|k,v| options["#{prefix}(#{k}i)"] = v.to_i > 9 ? v.to_s : "0#{v}" }
  options
end
