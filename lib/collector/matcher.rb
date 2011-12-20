module Collector
  class Matcher

    def initialize
      @location_patterns = []
      @time_patterns     = []
    end

    def add_location_pattern(regex, options, &block)
      @location_patterns << pattern_hash_for(regex, options, &block)
    end

    def add_time_pattern(regex, options, &block)
      if options[:included_parts].nil?
        raise ArgumentError.new('ArgumentError: :included_parts is required for time patterns')
      end
      @time_patterns << pattern_hash_for(regex, options, &block)
    end

    def match(text, truck, data = {})
      @matched_ranges = []

      @location_patterns.each do |pattern|
        text.scan(pattern[:regex]) do |match|

          # delegate address processing to a block if one was given, otherwise just geocode the result
          if pattern[:block].nil?
            result = Geocoder.search(address_for(pattern, $~, truck)).first
          else
            result = pattern[:block].call(pattern, $~, truck)
          end

          unless result.nil?
            first, last  = $~.offset(0)
            time_info    = match_time(text[last..-1])
            last        += time_info[:index]

            unless overlap((first..last), @matched_ranges)
              # WE NEED TO FIND A WAY TO LOG THIS INFO
              # puts "#{time_info[:index]} -- #{time_info[:start]} -- #{time_info[:finish]}"
              # puts "#{address_for(pattern, $~, truck)} -- #{result.latitude},#{result.longitude}\n#{text}\n\n"

              truck.locations.create(
                lat:         result.latitude,
                lng:         result.longitude,
                starting_at: time_info[:start],
                ending_at:   time_info[:finish],
                source:      text
              )
            end
          end
        end
      end

      truck.data_points.create(data: { text: text }.merge(data).to_json)
    end

  private

    def match_time(text)
      @time_patterns.each do |pattern|
        text.scan(pattern[:regex]) do |match|
          start = Chronic.parse($~[pattern[:included_parts][0]])
          if pattern[:included_parts].length > 1
            finish = Chronic.parse($~[pattern[:included_parts][1]])
          else
            finish = start
            start = Time.now
          end
          first, last = $~.offset(0)
          return { index: last, start: start, finish: finish }
        end
      end

      return { index: 0, start: Time.now, finish: Time.now.tomorrow.midnight }
    end

    # generate a new pattern hash
    def pattern_hash_for(regex, options, &block)
      {
        replacements:   [],
        included_parts: []
      }.merge(options).merge(regex: regex, block: block)
    end

    # generate an address string for geocoding
    def address_for(pattern, match_data, truck)
      extracted_part = if pattern[:included_parts].empty?
        match_data[0].strip
      else
        pattern[:included_parts].inject("") do |memo, part|
          memo += (part.is_a?(Fixnum)) ? match_data[part].strip : part
        end
      end
      "#{extracted_part}, #{truck.city}, #{truck.state}"
    end

    # simple utility method to determine if there is any offset overlap
    def overlap(new_range, existing_ranges)
      existing_ranges.each do |range|
        return true if range.include?(new_range.first) || range.include?(new_range.last)
      end
      existing_ranges << new_range
      false
    end
  end
end
