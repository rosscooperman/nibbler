require "spec_helper"

describe Page do
  describe "validations + associations" do
    before do
      @page = FactoryGirl.build(:page)
    end

    it { @page.should validate_presence_of(:title) }
    it { @page.should validate_presence_of(:slug)  }
    it { @page.should validate_presence_of(:body)  }

    it "should validate uniquness of slug" do
      @page1 = @page = FactoryGirl.create(:page)
      @page2 = FactoryGirl.build(:page, :slug => @page1.slug)
      @page2.should_not be_valid
      @page2.slug = "somethingelse"
      @page2.should be_valid
    end


  end
end

# == Schema Information
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

