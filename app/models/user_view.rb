# == Schema Information
#
# Table name: user_view
#
#  id                        :integer(4)      default(0), not null, primary key
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  time_zone                 :string(255)
#  type                      :string(255)
#  message_one               :string(255)
#  message_two               :string(255)
#  message_three             :string(255)
#  device_token              :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

class UserView < ActiveRecord::Base
  set_table_name "user_view"
end
