require "spec_helper"

module ListFormHelpers
  def setup_helper!
    @output_buffer = ""
    helper.output_buffer = @output_buffer
    helper.stub!(:spec_mocks_mock_path).and_return "/foo/bar"
    helper.stub!(:spec_mocks_mock_url).and_return "http://example.com/foo/bar"
    helper.stub!(:spec_mocks_mocks_path).and_return "/foo/bar"
    helper.stub!(:spec_mocks_mocks_url).and_return "http://example.com/foo/bar"

    @controller = Class.new do
      attr_reader :url_for_options
      def url_for(options)
        @url_for_options = options
        "http://www.example.com"
      end
    end.new
    
    helper.controller = @controller
  end

  attr_reader :output_buffer

  def using_form_for
    out = ""

    helper.form_for @obj do |f|
      out = yield(f)
    end

    out
  end
end

describe "list forms" do
  describe "a helper" do
    describe "dl_create_or_update_button" do
      include ListFormHelpers

      before(:each) do
        @obj = mock('ar object', :new_record? => false, :id => 17)
        setup_helper!
        helper.stub!(:create_cancel_url).and_return "create/cancel/url"
      end

      it "should produce a dt" do
        out = using_form_for do |f|
          f.dl_create_or_update_button
        end
        
        out.should include("<dt>")
      end

      it "should produce a dd with class 'buttons'" do
        out = using_form_for do |f|
          f.dl_create_or_update_button
        end

        out.should =~ /<dd class="buttons">.*<\/dd>/
      end

      it "should create a submit button with the text 'Create' when it's a new record" do
        @obj.stub!(:new_record?).and_return true

        out = using_form_for do |f|
          f.dl_create_or_update_button
        end

        out.should =~ /<input .* value="Create" \/>/
      end

      it "should use optional create text" do
        @obj.stub!(:new_record?).and_return true

        out = using_form_for do |f|
          f.dl_create_or_update_button(nil, nil, "Create Text")
        end

        out.should =~ /<input .* value="Create Text" \/>/
      end

      it "should use the default text of 'Update' when a saved record" do
        @obj.stub!(:new_record?).and_return false

        out = using_form_for do |f|
          f.dl_create_or_update_button
        end

        out.should =~ /<input .* value="Update" \/>/
      end

      it "should allow the update text to be specified" do
        @obj.stub!(:new_record?).and_return false

        out = using_form_for do |f|
          f.dl_create_or_update_button(nil, nil, nil, "Update Text")
        end

        out.should =~ /<input .* value=\"Update Text\" \/>/
      end

      it "should add the Cancel link" do
        @obj.stub!(:new_record?).and_return true

        out = using_form_for do |f|
          f.dl_create_or_update_button
        end

        out.should =~ /<a href=".*"\>Cancel<\/a>/
      end

      it "should add the the create link with the create_cancel_url when the object is a new record" do
        pending 'todo'
        @obj.stub!(:new_record?).and_return true

        out = using_form_for do |f|
          f.dl_create_or_update_button
        end

        out.should =~ /<a href="http:\/\/www.example.com">Cancel<\/a>/
      end

      it "should add the the create link with the update_cancel_url when the object is saved" do
        pending 'todo'
        @obj.stub!(:new_record?).and_return false

        out = using_form_for do |f|
          f.dl_create_or_update_button
        end

        out.should =~ /<a href="http:\/\/www.example.com">Cancel<\/a>/
      end

      it "should add 'or' between Create and Cancel" do
        @obj.stub!(:new_record?).and_return true

        out = using_form_for do |f|
          f.dl_create_or_update_button
        end

        out.should =~ /Create.* or .*Cancel/
      end
    end

    describe "ul_create_or_update_button" do
      include ListFormHelpers

      before(:each) do
        @obj = mock('ar object', :new_record? => false, :id => 17)
        setup_helper!
        helper.stub!(:create_cancel_url).and_return "create/cancel/url"
      end

      it "should include a li" do
        out = using_form_for do |f|
          f.ul_create_or_update_button
        end

        out.should =~ /<li.*><\/li>/
      end

      it "should include the Create and Cancel buttons for a new record" do
        @obj.stub!(:new_record?).and_return true

        out = using_form_for do |f|
          f.ul_create_or_update_button
        end

        out.should =~ /<li.*>.*Create.*or.*Cancel.*<\/li>/
      end
    end

    describe "tag helper" do
      it "should produce a self-closing tag" do
        helper.tag(:br).should == "<br />"
      end

      it "should use the attributes given" do
        helper.tag(:img, :src => "http://google.com").should == "<img src=\"http://google.com\" />"
      end

      it "should not close a tag if passing true as it's third param" do
        helper.tag(:div, { }, true).should == "<div>"
      end
      
      it "should have no attributes if given nil as it's second param" do
        helper.tag("br", nil).should == "<br />"
      end

      it "should escape the values given if the last param is false" do
        out = helper.tag("img", { :src => "open &amp; shut.png" }, false, false)
        out.should == '<img src="open &amp; shut.png" />'
      end

      describe "when the name of the field is 'textarea'" do
        it "should set the class to 'text'" do
          out = helper.tag(:textarea)
          out.should == "<textarea class=\"text\" />"
        end

        it "should not set the class to 'text' if it already has a class (as a symbol)" do
          out = helper.tag(:textarea, :class => "foo")
          out.should == "<textarea class=\"foo\" />"
        end

        it "should not set the class to 'text' if it already has a class (as a string)" do
          out = helper.tag(:textarea, "class" => "foo")
          out.should == "<textarea class=\"foo\" />"
        end

        it "should set the class to text when the name field is passed a string" do
          out = helper.tag("textarea")
          out.should == "<textarea class=\"text\" />"
        end
      end

      describe "when an input tag and the type param is set" do
        it "should not modify the hash if there is a class set" do
          out = helper.tag(:input, :type => :foo, :class => "foobar")
          out.should == '<input class="foobar" type="foo" />'
        end

        it "should not modify the hash if the type='hidden'" do
          out = helper.tag(:input, :type => "hidden")
          out.should == '<input type="hidden" />'
        end

        it "should use the class name as the type name" do
          out = helper.tag(:input, :type => "foo")
          out.should == '<input class="foo" type="foo" />'
        end

        it "should use the correct class name as the type name" do
          out = helper.tag(:input, :type => "one")
          out.should == '<input class="one" type="one" />'
        end

        it "should add the class bn if it's type is submit" do
          out = helper.tag(:input, :type => "submit")
          out.should == '<input class="submit bn" type="submit" />'
        end

        it "should add the class bn if it's type is reset" do
          out = helper.tag(:input, :type => "reset")
          out.should == '<input class="reset bn" type="reset" />'
        end

        it "should add the class 'text' if it's type is password" do
          out = helper.tag(:input, :type => "password")
          out.should == '<input class="password text" type="password" />'
        end
      end

      describe "when the tag is input, but there is no type option set" do
        it "should not set the class" do
          out = helper.tag(:input)
          out.should == "<input />"
        end
      end
    end

    describe "content tag" do
      it "should create a tag which wraps it's output" do
        helper.content_tag(:p, "Hello world!").should == "<p>Hello world!</p>"
      end

      it "should set a class if given" do
        out = helper.content_tag(:div, content_tag(:p, "Hello world!"), :class => "strong")
        out.should == '<div class="strong"><p>Hello world!</p></div>'
      end

      it "should take the block format" do
        out = helper.content_tag :div, :class => "strong" do
          helper.concat("Hello world!")
        end
        
        out.should == '<div class="strong">Hello world!</div>'
      end

      it "should set the same css options as the tag helper" do
        helper.content_tag(:textarea, "foo").should == '<textarea class="text">foo</textarea>'
      end
    end
  end
end
