class Conductor
  class AttributeParser
    def self.parse(hash)
      new.parse(hash)
    end

    def parse(hash)
      new_hash = {}
      multi_params = []

      hash.each do |key, value|
        if key.to_s.include?("(")
          multi_params << [key, value]
        else
          new_hash[key] = value
        end
      end

      new_hash.merge(combine(multi_params))
    end

    def combine(multi_params)
      attributes = {}

      multi_params.each do |key, value|
        if key =~ /(.*)\((\d)+(.*)\)/
          attributes[$1] ||= []
          attributes[$1] << [$2, convert_value(value, $3)]
        end
      end

      attributes.each do |name, values|
        attributes[name] = order_values(values)
      end

      attributes
    end

    def order_values(values)
      values.sort_by { |v| v.first }.collect { |v| v.last }
    end

    def convert_value(value, type)
      case type
      when "i"
        value.to_i
      when "s"
        value.to_s
      when "f"
        value.to_f
      when "a"
        value.to_a
      end
    end
  end
end