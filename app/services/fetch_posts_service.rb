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

      feeds.each do |feed|
        open(feed.url) do |rss|
          feed = RSS::Parser.parse(rss)
          feed.channel.items.each do |item|
            posts << Post.new(item.title, item.link, item.description, item.pubDate)
          end
        end
      end

      posts.sort_by { |post| post.pub_date }.reverse
    end
  end
end
