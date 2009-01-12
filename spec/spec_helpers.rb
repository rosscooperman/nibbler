module SpecHelpers
  def stub_mailer_callbacks(object)
    object.stub!(:after_create).and_return(nil)
    object
  end

  def random_string(min = 10, flex = 10)
    Faker::Lorem::words(min + rand(flex)).join(" ").capitalize
  end

  def logger
    RAILS_DEFAULT_LOGGER
  end
end
