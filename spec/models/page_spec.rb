require "spec_helper"

describe Page do
  describe "validations + associations" do
    before do
      @page = Page.new
    end

    it { @page.should validate_presence_of(:title) }
  end
end

# == Schema Information
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  header     :string(255)
#  body       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

