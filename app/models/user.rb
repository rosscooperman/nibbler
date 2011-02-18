# == Schema Information
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
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

class User < ActiveRecord::Base
  include Authenticated

  validates_presence_of :email
  validates_format_of   :email, :with => Format::EMAIL

  defaults :time_zone => "Eastern Time (US & Canada)"

  after_create :send_welcome_email

  def admin?
    false
  end

  def send_welcome_email
    UserMailer.delay.signup(self)
  end

  def send_password_reset_email
    UserMailer.delay.password_reset_link(self)
  end
end
