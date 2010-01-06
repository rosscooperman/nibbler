# == Schema Information
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
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

  validates_presence_of :username
  validates_presence_of :email
  validates_format_of   :email, :with => Format::EMAIL

  defaults :time_zone => "Eastern Time (US & Canada)"

  def send_password_reset_email
    UserMailer.deliver_password_reset_link(self)
  end
end
