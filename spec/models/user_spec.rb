require "spec_helper"

describe User do
  before do
    @user = User.new
  end

  ["username", "email", "password", "password_confirmation"].each do |field|
    it "requires a #{field}" do
      @user.should validate_presence_of(field)
    end
  end

  describe "validations + associations" do
    it { @user.should validate_presence_of(:username) }
    it { @user.should validate_presence_of(:email) }

    it "should not be valid with an invalid email address" do
      @user.email = "adfasdfad@asdfasdf"
      @user.should have(1).error_on(:email)
    end
  end

  describe "mailers" do
    before do
      @user = new_user
    end

    it "should be able to send the password reset email" do
      UserMailer.should_receive(:deliver_password_reset_link).with(@user)
      @user.send_password_reset_email
    end

    it "should send the welcome email on creation" do
      UserMailer.should_receive(:deliver_signup).with(@user)
      @user.save!
    end
  end
end

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
#  time_zone                 :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

