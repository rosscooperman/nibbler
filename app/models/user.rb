class User < ActiveRecord::Base
  include Authenticated

  defaults :time_zone    => "Eastern Time (US & Canada)"

end
