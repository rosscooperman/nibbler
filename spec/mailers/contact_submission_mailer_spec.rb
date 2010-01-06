require File.dirname(__FILE__) + '/../spec_helper'

describe ContactSubmissionMailer do
  before do
    @submission = new_contact_submission({
      :name    => "Scott Taylor",
      :subject => "My Subject",
      :email   => "scott@railsnewbie.com",
      :body    => "Here is my question"
    })

    setup_mailer
  end

  def now
    @now ||= Time.now.utc
  end

  it "should send an email for a contact submission" do
    @expected.subject  = "My Subject"
    @expected.from     = "Scott Taylor <#{SETTINGS[:email][:contact_submission_recipient]}>"
    @expected.to       = SETTINGS[:email][:contact_submission_recipient]
    @expected.body     = read_fixture(:contact_submission, :simple_submission)
    @expected.reply_to = "scott@railsnewbie.com"
    @expected.date     = now

    email = ContactSubmissionMailer.create_submission(@submission, now).encoded
    email.should == @expected.encoded
  end
end
