require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do
  before(:each) do
    setup_mailer
    @user = new_user(:username => "bob_fixture", :email => "bob.fixture@example.com")
  end

  it "should send mails for password reset link" do
    @user.stub!(:password_reset_hash).and_return("75d86eb0bb16832e8af11f6042139736c04945be")
    @user.stub!(:id).and_return("123")

    @expected.subject = "Create a new password"
    @expected.from    = SETTINGS[:email][:from]
    @expected.to      = "bob.fixture@example.com"
    @expected.body    = read_fixture(:user, :password_reset_link)
    @expected.date    = Time.now.utc

    UserMailer.create_password_reset_link(@user, @expected.date).encoded.should == @expected.encoded
  end
end
