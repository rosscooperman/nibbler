module Collector
  class Twitter < Base

    def self.update(truck)
      options = {
        count:       200,
        trim_user:   true,
        include_rts: false
      }

      last_data_point = truck.data_points.order('id DESC').first
      unless last_data_point.nil?
        data = JSON.parse(last_data_point.data)
        options[:since_id] = data['tweet_id'] unless data['tweet_id'].nil?
      end

      tweets = ::Twitter.user_timeline(truck.source_data.sub(/^\@/, ''), options).reverse
      scan(tweets, truck)
      nil
    end

  private

    def self.scan(tweets, truck)
      tweets.reject{ |tweet| tweet.text.match(/^@/) }.each do |tweet|
        matches = matcher.match(tweet.text, truck, tweet_id: tweet.id)
      end
    end
  end
end
