require "spec_helper"

describe User do
  before do
    @user = User.new
  end

  describe "validations + associations" do
    it { @user.should validate_presence_of(:email) }
    it { @user.should validate_presence_of(:password) }
    it { @user.should validate_presence_of(:password_confirmation) }

    it "should not be valid with an invalid email address" do
      @user.email = "adfasdfad@asdfasdf"
      @user.should have(1).error_on(:email)
    end
  end

  describe "mailers" do
    before do
      @user = new_user
      @mock_message = mock_model("Message", :deliver => true)
    end

    it "should be able to send the password reset email" do
      UserMailer.should_receive(:password_reset_link).with(@user).and_return(@mock_message)
      @user.send_password_reset_email
    end

    it "should send the welcome email on creation" do
      UserMailer.should_receive(:signup).with(@user).and_return(@mock_message)
      @user.save!
    end
  end

  describe "types" do
    before do
      @user = User.new
    end

    it "should not be an admin?" do
      @user.should_not be_an_admin
    end
  end
end