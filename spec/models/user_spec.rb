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

require File.dirname(__FILE__) + "/../spec_helper"

describe User do
  before do
    @user = User.new
  end

  ["username", "email", "password", "password_confirmation"].each do |field|
    it "requires a #{field}" do
      @user.should validate_presence_of(field)
    end
  end
end
