require "spec_helper"

module Spec
  module Rails
    describe Matchers do
      before do
        @example = Class.new do
          include Spec::Matchers
          include Spec::Rails::Matchers
        end.new
      end

      describe "belongs_to" do
        before do
          @comment = Comment.new
        end

        it "should respond to belong_to" do
          @example.should respond_to(:belong_to)
        end

        it "should match if the object has a belongs to association" do
          @example.belong_to(:post).matches?(@comment).should be_true
        end

        it "should not match if the object does not have the association" do
          @example.belong_to(:foobar).matches?(@comment).should be_false
        end
      end

      describe "valid associations" do
        before do
          @comment = Comment.new
          @invalid_association_object = InvalidAssociationClass.new
        end

        it "should have valid associations when all associations are valid" do
          @example.have_valid_associations.matches?(@comment).should be_true
        end

        it "should not have valid associations when an association is invalid" do
          @example.have_valid_associations.matches?(@invalid_association_object).should be_false
        end

        it "should use the failed association name in the failure message" do
          matcher = @example.have_valid_associations
          matcher.matches?(@invalid_association_object)
          matcher.failure_message.should == "invalid or nonexistent association \"foos\" on InvalidAssociationClass"
        end
      end
    end
  end
end