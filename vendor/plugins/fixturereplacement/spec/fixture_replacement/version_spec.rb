require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  it "should be at version 3.0.0" do
    FixtureReplacement::VERSION.should == "3.0.0"
  end
end
