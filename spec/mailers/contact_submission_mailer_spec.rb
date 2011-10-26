require 'spec_helper'

describe ContactSubmissionMailer do
  before do
    @submission = FactoryGirl.build(:contact_submission, {
      :name    => "Scott Taylor",
      :subject => "My Subject",
      :email   => "scott@railsnewbie.com",
      :body    => "Here is my question"
    })

    setup_mailer
  end

  def now
    @now ||= Time.now
  end

  it "should send an email for a contact submission" do
    # Send the email, then test that it got queued
    email = ContactSubmissionMailer.submission(@submission, now).deliver
    ActionMailer::Base.deliveries.should_not be_empty

    # Test the body of the sent email contains what we expect it to
    email.from.should == [SETTINGS[:email][:contact_submission_recipient]]
    email.to.should == [SETTINGS[:email][:contact_submission_recipient]]
    email.body.should == read_fixture(:contact_submission, :simple_submission).join
    email.reply_to.should == ["scott@railsnewbie.com"]
  end
end
