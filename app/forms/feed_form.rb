class FeedForm
  include MiniForm::Model

  model :feed, attributes: %i(url title)

  delegate :persisted?, to: :feed

  validates :url, presence: true, format: { with: URI.regexp }, allow_blank: false
  validates :title, presence: true

  def initialize(feed = Feed.new)
    @feed = feed
  end

  def perform(attributes)
    self.attributes = attributes.merge(title: parsed_title(attributes[:url]))

    return false unless valid?

    feed.save!
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Feed')
  end

  private

  def parsed_title(url)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.channel.title
    end
  rescue
  end
end
