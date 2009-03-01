# == Schema Information
# Schema version: 20090105200818
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  username                  :string(255)
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  created_at                :datetime
#  updated_at                :datetime
#  time_zone                 :string(255)
#

class User < ActiveRecord::Base
  include Authenticated

  defaults :time_zone    => "Eastern Time (US & Canada)"

end
