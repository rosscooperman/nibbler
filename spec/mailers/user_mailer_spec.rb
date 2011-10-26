require 'spec_helper'

describe UserMailer do
  before(:each) do
    setup_mailer
    @user = FactoryGirl.build(:user, :email => "bob.fixture@example.com")
  end

  it "should send mails for password reset link" do
    @user.stub!(:password_reset_hash).and_return("75d86eb0bb16832e8af11f6042139736c04945be")
    @user.stub!(:id).and_return("123")

    # Send the email, then test that it got queued
    email = UserMailer.password_reset_link(@user, @expected.date).deliver
    ActionMailer::Base.deliveries.should_not be_empty

    # Test the body of the sent email contains what we expect it to
    email.subject.should == "Create a new password"
    email.from.should == [SETTINGS[:email][:from]]
    email.to.should == ["bob.fixture@example.com"]
    email.body.should == read_fixture(:user, :password_reset_link).join
  end

  it "should send an email when signing up" do
    # Send the email, then test that it got queued
    email = UserMailer.signup(@user, @expected.date).deliver
    ActionMailer::Base.deliveries.should_not be_empty

    # Test the body of the sent email contains what we expect it to
    email.subject.should == "Welcome"
    email.from.should == [SETTINGS[:email][:from]]
    email.to.should == ["bob.fixture@example.com"]
    email.body.should == read_fixture(:user, :signup).join
  end
end
