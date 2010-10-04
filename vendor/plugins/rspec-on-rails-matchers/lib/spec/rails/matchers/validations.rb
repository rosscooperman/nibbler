RSpec::Matchers.define :validate_presence_of do |attribute|
  match do |object|
    if !object.respond_to?("#{attribute}=")
      false
    else
      object.send("#{attribute}=", nil)
      !object.valid? && object.errors[attribute].any?
    end
  end
end

RSpec::Matchers.define :validate_length_of do |attribute, options|
  if options.has_key? :within
    min = options[:within].first
    max = options[:within].last
  elsif options.has_key? :is
    min = options[:is]
    max = min
  elsif options.has_key? :minimum
    min = options[:minimum]
  elsif options.has_key? :maximum
    max = options[:maximum]
  end

  invalid = false
  if !min.nil? && min >= 1
    object.send("#{attribute}=", 'a' * (min - 1))
    invalid = !object.valid? && object.errors[attribute].any?
  end

  if !max.nil?
    object.send("#{attribute}=", 'a' * (max + 1))
    invalid ||= !object.valid? && object.errors[attribute].any?
  end

  invalid
end

RSpec::Matchers.define :validate_uniqueness_of do |attribute|
  match do |object|
    object.class.stub!(:with_exclusive_scope).and_return([object])
    !object.valid? && object.errors[attribute].any?
  end
end

RSpec::Matchers.define :validate_confirmation_of do |attribute|
  match do |object|
    object.send("#{attribute}_confirmation=", 'asdf')
    !object.valid? && object.errors[attribute].any?
  end
end

RSpec::Matchers.define :validate_inclusion_of do |attribute, options|
  match do |object|
    values = options[:in]
    booleans = assign_and_validate_values(object, attribute, values)
    booleans.all?
  end
end

module RSpec
  module Matchers

  private
    def assign_and_validate_value(model, attribute, value)
      model.send("#{attribute}=", value)
      model.valid?
      !model.errors.invalid?(attribute)
    end

    def assign_and_validate_values(model, attribute, values)
      values.map do |value|
        assign_and_validate_value(model, attribute, value)
      end
    end
  end
end