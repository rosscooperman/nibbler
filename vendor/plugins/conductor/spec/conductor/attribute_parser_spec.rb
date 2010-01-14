require "spec_helper"

class Conductor
  describe AttributeParser do
    describe "parsing with a hash" do
      before do
        @parser = AttributeParser.new
      end

      it "should return a typical key-value pair unchanged" do
        @parser.parse({:foo => "bar"}).should == {:foo => "bar"}
      end

      it "should return the correct keys and values" do
        @parser.parse({:one => "two"}).should == {:one => "two"}
      end

      it "should convert one param with an '(1i)' into an integer" do
        @parser.parse({"one(1i)" => "1"}).should == {"one" => [1]}
      end

      it "should convert whatever is given to an integer" do
        @parser.parse({"one(1i)" => "2"}).should == {"one" => [2]}
      end

      it "should convert s to a string" do
        @parser.parse({"one(1s)" => 3}).should == {"one" => ["3"]}
      end

      it "should convert f to a float" do
        @parser.parse({"one(1f)" => "2.5"}).should == {"one" => [2.5]}
      end

      it "should convert a to an array" do
        @parser.parse({"one(1a)" => "2.5"}).should == {"one" => [["2.5"]]}
      end

      it "should use the correct key" do
        @parser.parse({"foo(1i)" => "1"}).should == {"foo" => [1]}
      end

      it "should merge values together" do
        @parser.parse({"one(1i)" => "1", "one(2i)" => "2"}).should == {"one" => [1, 2]}
      end

      it "should merge values out of order" do
        @parser.parse({"one(1i)" => "2", "one(2i)" => "1"}).should == {"one" => [2, 1]}
      end
    end
  end
end