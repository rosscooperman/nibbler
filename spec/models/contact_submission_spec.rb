require "spec_helper"

describe ContactSubmission do
  describe "validations" do
    before(:each) do
      @contact_submission = ContactSubmission.new
    end

    it { @contact_submission.should validate_presence_of(:name) }
    it { @contact_submission.should validate_presence_of(:email) }
    it { @contact_submission.should validate_presence_of(:subject) }
    it { @contact_submission.should validate_presence_of(:body) }

    it "should be valid with a valid email address" do
      @contact_submission.email = "scott@railsnewbie.com"
      @contact_submission.should have(0).errors_on(:email)
    end

    it "should not be valid with an invalid email address" do
      @contact_submission.email = "foo@foo"
      @contact_submission.should have(1).error_on(:email)
    end
  end

  describe "creation" do
    it "should send the email" do
      submission = new_contact_submission
      ContactSubmissionMailer.should_receive(:create_submission).with(submission)
      submission.save!
    end
  end
end