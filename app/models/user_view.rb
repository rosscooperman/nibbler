# == Schema Information
#
# Table name: user_view
#
#  id                        :integer(4)      default(0), not null
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  time_zone                 :string(255)
#  type                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

class UserView < ActiveRecord::Base
  set_table_name "user_view"
end
