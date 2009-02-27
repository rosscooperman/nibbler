require File.dirname(__FILE__) + "/spec_helper"

describe TruncateTable, "'s version" do
  it "should be at 1.0.0" do
    TruncateTable::Version::VERSION.should == "1.0.0"
  end
end
