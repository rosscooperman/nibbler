require File.dirname(__FILE__) + "/../spec_helper"

module FixtureReplacement
  describe AttributeBuilder do  
    it "should add the instance to the global attributes" do
      a = AttributeBuilder.new(:foo)
      AttributeBuilder.instances.should == [a]
    end
    
    it "should have no instances when none have been created" do
      AttributeBuilder.instances.should == []
    end
    
    it "should have two instances when two have been created" do
      a1 = AttributeBuilder.new(:foo)
      a2 = AttributeBuilder.new(:foo)
      AttributeBuilder.instances.should == [a1, a2]
    end
    
    it "should have the fixture name as accessible" do
      a1 = AttributeBuilder.new(:foo)
      a1.fixture_name.should == :foo
    end
    
    it "should have the from attribute as nil, if none provided" do
      a1 = AttributeBuilder.new(:foo)
      a1.from.should be_nil
    end
    
    it "should have the from attribute as the symbol of the attribute from which it derives" do
      a1 = AttributeBuilder.new(:foo, :from => :bar)
      a1.from.should == :bar
    end
    
    it "should be able to find the Attribute by fixture name" do
      a = AttributeBuilder.new(:baz)
      AttributeBuilder.find_by_fixture_name(:baz).should == a
    end
    
    it "should find no attributes for fixture_name :baz, if it was never created" do
      a = AttributeBuilder.new(:bar)
      AttributeBuilder.find_by_fixture_name(:baz).should be_nil
    end
    
    it "should find no attributes for fixture_name :baz, if no fixture at all was ever created" do
      AttributeBuilder.find_by_fixture_name(:baz).should be_nil
    end
    
    it "should have the class name if specified" do
      AttributeBuilder.new(:foo, :class => Object).active_record_class.should == Object
    end
    
    it "should use the class name of the fixture_name, camel-cased, if the class is unspecified, and the fixture uninherited" do
      AttributeBuilder.new(:object).active_record_class.should == Object
    end
    
    it "should use the class name of the inherited attribute, if specified" do
      AttributeBuilder.new(:foo, :class => Object)
      AttributeBuilder.new(:bar, :from => :foo).active_record_class.should == Bar
    end
    
    it "should prefer the constantized name to the derived name" do
      AttributeBuilder.new(:user)
      AttributeBuilder.new(:admin, :from => :user).active_record_class.should == Admin
    end
    
    it "should use the derived name if the constantized name fails (doesn't exist)" do
      AttributeBuilder.new(:foo)
      no_constant = AttributeBuilder.new(:no_constant, :from => :foo)
      no_constant.active_record_class.should == Foo
    end
    
    it "should raise a name error if it has no class, the name can't be constantized, and is derived, but the derived class can't be constantized" do
      builder_one = AttributeBuilder.new(:does_not_exist)
      builder_two = AttributeBuilder.new(:also_does_not_exist, :from => :does_not_exist)
      
      lambda {
        builder_two.active_record_class
      }.should raise_error(NameError)
    end
    
    it "should not raise an error if the model ends with 's'" do
      AttributeBuilder.new(:actress).active_record_class.should == Actress
    end
  end  
end
