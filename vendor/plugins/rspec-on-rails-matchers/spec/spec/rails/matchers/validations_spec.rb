require "spec_helper"

module Spec
  module Rails
    describe Matchers, "validations" do
      before do
        @example = Class.new do
          include Spec::Matchers
          include Spec::Rails::Matchers
        end.new
      end

      describe "validates_presence_of" do
        before do
          @comment = Comment.new
        end

        it "should match if the object has a validates_presence_of" do
          @example.validate_presence_of(:post).matches?(@comment).should be_true
        end

        it "should not match if the object does not have the association" do
          @example.validate_presence_of(:an_attr_accessor).matches?(@comment).should be_false
        end

        it "should not match if the object does not respond to the method" do
          @example.validate_presence_of(:foobar).matches?(@comment).should be_false
        end
      end

      describe "validate_inclusion_of" do
        before do
          @boolean = Boolean.new
        end

        it "should be true if it is the same list" do
          matcher = @example.validate_inclusion_of(:null_not_allowable, :in => [true, false])
          matcher.matches?(@boolean).should be_true
        end

        it "should not be true if one of the values is not true" do
          @example.validate_inclusion_of(:null_not_allowable, :in => [nil]).matches?(@boolean).should be_false
        end
      end

      describe "validate_boolean_of" do
        before do
          @boolean = Boolean.new
        end

        it "should be true if it is valid when [true, false]" do
          matcher = @example.validate_boolean_of(:null_not_allowable)
          matcher.matches?(@boolean).should be_true
        end

        it "should not be true if it allows a nil" do
          matcher = @example.validate_boolean_of(:null_allowable)
          matcher.matches?(@boolean).should be_false
        end
      end
    end
  end
end