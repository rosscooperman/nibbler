# == Schema Information
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  time_zone                 :string(255)     default("Eastern Time (US & Canada)")
#  type                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

require "spec_helper"

describe Administrator do
  it "should be a kind of user" do
    Administrator.new.should be_a_kind_of(User)
  end

  it "should have a type column" do
    Administrator.column_names.should include("type")
  end

  describe "types" do
    before do
      @admin = Administrator.new
    end

    it "should be an admin?" do
      @admin.should be_an_admin
    end
  end
end

