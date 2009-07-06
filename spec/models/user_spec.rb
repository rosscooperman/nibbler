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
