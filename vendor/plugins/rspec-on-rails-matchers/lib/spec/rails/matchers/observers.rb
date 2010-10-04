RSpec::Matchers.define :observe do |observed_class|
  match do |observing_class|
    observed_classes = observing_class.observed_classes.flatten
    observed_classes.include?(observed_classes)
  end
end