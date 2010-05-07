require "spec_helper"

describe Page do
  describe "validations + associations" do
    before do
      @page = Page.new
    end

    it { @page.should validate_presence_of(:title) }
    it { @page.should validate_presence_of(:slug)  }
    it { @page.should validate_presence_of(:body)  }

    it "should validate uniquness of slug" do
      @page1 = create_page
      @page2 = new_page(:slug => @page1.slug)
      @page2.valid?.should_not be_true
      @page2.slug = "somethingelse"
      @page2.valid?.should be_true
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