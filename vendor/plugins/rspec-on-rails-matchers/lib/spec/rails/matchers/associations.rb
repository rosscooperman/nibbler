module Spec
  module Rails
    module Matchers
      def belong_to(association)
        return simple_matcher("model to belong to #{association}") do |model|
          model = model.class if model.is_a? ActiveRecord::Base
          model.reflect_on_all_associations(:belongs_to).find { |a| a.name == association }
        end
      end

      def have_many(association)
        return simple_matcher("model to have many #{association}") do |model|
          model = model.class if model.is_a? ActiveRecord::Base
          model.reflect_on_all_associations(:has_many).find { |a| a.name == association }
        end
      end

      def have_one(association)
        return simple_matcher("model to have one #{association}") do |model|
          model = model.class if model.is_a? ActiveRecord::Base
          model.reflect_on_all_associations(:has_one).find { |a| a.name == association }
        end
      end

      def have_and_belong_to_many(association)
        return simple_matcher("model to have and belong to many #{association}") do |model|
          model = model.class if model.is_a? ActiveRecord::Base
          model.reflect_on_all_associations(:has_and_belongs_to_many).find { |a| a.name == association }
        end
      end

      class HaveValidAssociationMatcher
        def matches?(model)
          @failed_association = nil
          @model_class = model.class

          model.class.reflect_on_all_associations.each do |assoc|
            model.send(assoc.name) rescue @failed_association = assoc.name
          end
          !@failed_association
        end

        def failure_message
          "invalid or nonexistent association \"#{@failed_association}\" on #{@model_class}"
        end
      end

      def have_valid_associations
        HaveValidAssociationMatcher.new
      end
    end
  end
end
