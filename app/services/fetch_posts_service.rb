class Post
  include ActiveModel::Model

  attr_reader :title, :link, :description, :pub_date

  def initialize(title, link, description, pub_date)
    @title = title
    @link = link
    @description = description
    @pub_date = pub_date
  end
end

class FetchPostsService
  class << self
    def perform
      feeds = Feed.default_order
      posts = []
      threads = []

      feeds.each do |feed|
        threads << Thread.new do
          open(feed.url) do |rss|
            parsed_feed = RSS::Parser.parse(rss)
            parsed_feed.channel.items.each do |item|
              posts << Post.new(item.title, item.link, item.description, item.pubDate)
            end
          end
        end
      end

      threads.map(&:join)

      posts.sort_by { |post| post.pub_date }.reverse
    end
  end
end
