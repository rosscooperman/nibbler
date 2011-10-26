require "spec_helper"

describe ContactSubmission do
  describe "validations" do
    before(:each) do
      @contact_submission = FactoryGirl.build(:contact_submission)
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
      submission = FactoryGirl.build(:contact_submission)
      mock_message = mock_model("Message", :deliver => true)
      ContactSubmissionMailer.should_receive(:submission).with(submission).and_return(mock_message)
      submission.save!
    end
  end
end
# == Schema Information
#
# Table name: contact_submissions
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  subject    :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

