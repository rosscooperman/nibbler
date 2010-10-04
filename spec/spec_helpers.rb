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

  module ControllerHelpers
    def setup_cookie_proxy!
      cookie_proxy = { }
      controller.stub!(:cookies).and_return cookie_proxy
      cookie_proxy
    end

    def log_in_with(user)
      controller.stub!(:current_user).and_return user
    end

    def log_in
      user = mock_model(User, :forget_me! => true)
      log_in_with(user)
      user
    end
  end
end

# FIXME : put this into the correct namespace
# module Spec
#   module Rails
#     module Example
#       class IndexExampleGroup < ModelExampleGroup
#       end
#     end
#   end
# end
#
# Spec::Example::ExampleGroupFactory.register(:index, Spec::Rails::Example::IndexExampleGroup)
#