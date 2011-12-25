require 'open-uri'

module Collector
  class Website < Base

    def self.update(truck)
      options = YAML.load("#{truck.source_data.strip}\n")
      page    = Hpricot(open(options['url']))

      scan(page.search(options['location_selector']).map(&:inner_html), truck)
        # regex = Regexp.new(options['location_regex'])
        # regex.match(location.inner_html) do |md|
        #   address = options['location_parts'].map{ |part| md[part] }.join(' ')
        #   CGI::unescape(
        # end
      # end
      nil
    end

  private

    def self.scan(entries, truck)
      entries.each do |entry|
        matcher.match(CGI::unescapeHTML(entry), truck)
      end
    end
  end
end
