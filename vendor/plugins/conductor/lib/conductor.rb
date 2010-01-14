$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
require "forwardable"
require "conductor/attribute_parser"

class Conductor
  extend Forwardable

  module Version
    MAJOR = 0
    MINOR = 1
    TINY  = 0

    STRING = "#{MAJOR}.#{MINOR}.#{TINY}"
  end

  class << self
    def conduct(obj, *fields)
      fields.each do |field|
        def_delegator obj, field
        def_delegator obj, "#{field}="
      end
    end

    def conduct_date(obj, field)
      def_delegator obj, field
      define_method "#{field}=" do |params|
        begin
          if date = Date.new(*params)
            send(obj).send("#{field}=", date)
          end
        rescue ArgumentError
        end
      end
    end
  end

  def initialize(controller)
    @controller = controller
    assign_values
  end

  def save
    if valid?
      save_models
      true
    else
      false
    end
  end

  def valid?
    return_values = models.map { |model| validate_model(model) }
    return_values.all?
  end

  def errors
    @errors ||= ActiveRecord::Errors.new(self)
  end

  def save_models
    models.each do |model|
      model.save!
    end
  end

  def models
    @models ||= []
  end

private

  def validate_model(model)
    returning model.valid? do
      model.errors.each do |error, text|
        errors.add(error, text)
      end
    end
  end

  def params
    @controller.params
  end

  def assign_values
    if params[:conductor]
      parse_params(params[:conductor]).each do |key, value|
        send("#{key}=", value)
      end
    end
  end

  def parse_params(params)
    AttributeParser.parse(params)
  end
end
