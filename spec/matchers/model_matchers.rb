module ModelMatchers

  class HaveValidAssociations
    def matches?(model)
      @failed_association = nil
      @model_class = model.class

      model.class.reflect_on_all_associations.each do |assoc|
        model.send(assoc.name, true) rescue @failed_association = assoc.name
      end
      !@failed_association
    end

    def failure_message
      "invalid or nonexistent association \"#{@failed_association}\" on #{@model_class}"
    end
  end

  def have_valid_associations
    HaveValidAssociations.new
  end

  # Acts
  
  def act_like_a_list_item(options = {})
    simple_matcher("act like a list item") do |model|
      [:position, :first?, :last?, :higher_item, :lower_item].all? do |method|
        model.respond_to?(method)
      end
    end
  end
  
  def act_as_slugable(options = {})
    return simple_matcher("act as slugable") do |model|
      [:acts_as_slugable_class, :source_column, :slug_column].all? do |method|
        model.respond_to?(method)
      end
    end
  end

  def act_as_taggable(options = {})
    return simple_matcher("act as taggable") do |model|
      [:tag_list, :tag_list=, :save_cached_tag_list, :save_tags, :tag_counts, :reload_with_tag_list].all? do |method|
        model.respond_to?(method)
      end
    end
  end

  def have_image(image_association_name = :image)
    return simple_matcher("have an image with association name '#{image_association_name}'") do |model|
      model.respond_to?(image_association_name)
    end
  end
  
  def have_upload(upload_association_name)
    return simple_matcher("have an upload with association name '#{upload_association_name}'") do |model|
      model.respond_to?(upload_association_name)
    end
  end
  
  def validate_inclusion_of(attribute, options)
    simple_matcher("validate inclusion of #{attribute} in #{options[:in].inspect}") do |model|
      model.send("#{attribute}=", "YARGLE BARGLE")
      return false if model.valid? || model.errors.on(attribute).empty?
      
      options[:in].all? do |value|
        model.send("#{attribute}=", value)
        model.valid? ? true : !model.errors.invalid?(attribute)
      end
    end
  end
  
  def validate_acceptance_of(attribute)
    simple_matcher("validate presence of #{attribute}") do |model|
      model.send("#{attribute}=", "0")
      !model.valid? && model.errors.invalid?(attribute)
    end
  end
  
end