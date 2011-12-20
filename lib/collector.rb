module Collector

  class Base

    A_TIME = "(\d{1,2}(:\d{2})?\s*(am|pm)?)"

    def self.add_location_pattern(regex, *args, &block)
      raise ArgumentError.new("ArgumentError: wrong number of arguments (#{args.length} for 1)") if args.length > 1
      options = (args.last.is_a?(Hash)) ? args.pop : {}
      matcher.add_location_pattern(regex, options, &block)
    end

    def self.add_time_pattern(regex, *args, &block)
      raise ArgumentError.new("ArgumentError: wrong number of arguments (#{args.length} for 1)") if args.length > 1
      options = (args.last.is_a?(Hash)) ? args.pop : {}
      matcher.add_time_pattern(regex, options, &block)
    end

    def self.matcher
      @@matcher ||= Matcher.new
    end

    def self.update(truck)
      raise "All data collectors must implement an update method"
    end

  private

    def self.add_default_patterns
      #
      # Date patterns
      #
      regex = /on\s+((\w+)\s+between\s+(\d+(th|rd|st|nd)\s*(st|ave)?)\s*(and|&|\/)\s*(\d+(th|rd|st|nd)\s*(st|ave)?))/i
      add_location_pattern(regex) do |pattern, md, truck|
        result1 = Geocoder.search("#{md[2].strip} & #{md[3].strip}, #{truck.city}, #{truck.state}").first
        result2 = Geocoder.search("#{md[2].strip} & #{md[7].strip}, #{truck.city}, #{truck.state}").first

        Geocoder::Result::Base.new(
          'latitude'  => (result1.latitude + result2.latitude) / 2,
          'longitude' => (result1.longitude + result2.longitude) / 2
        )
      end

      regex = /(\d+(th|rd|st|nd)\s*(st|ave)?)\s*(and|&|\/)\s*(\d+(th|rd|st|nd)\s*(st|ave)?)/i
      add_location_pattern(regex, included_parts: [ 1, ' & ', 5 ])

      #
      # Time patterns
      #
      regex = /(\d{1,2}(:\d{2})?\s*(am|pm)?)\s*(-|to)\s*(\d{1,2}(:\d{2})?\s*(am|pm)?)/i
      add_time_pattern(regex, included_parts: [ 1, 5 ])

      regex = /(til|till|until)\s+(\d{1,2}(:\d{2})?\s*(am|pm)?)/i
      add_time_pattern(regex, included_parts: [ 2 ])
    end
    add_default_patterns
  end
end
