# frozen_string_literal: true

require 'spec_helper'

describe FetchPostsService do
  let!(:feed1) do
    create(:feed, title: 'NASA Breaking News',
                  url: 'http://something.com/something.rss' )
  end
  let!(:feed2) do
		create(:feed, title: 'NASA Most Breaking News',
                  url: 'http://something.com/something-more.rss' )
	end

	let(:set1) do
		{ title: 'Title1',
			description: 'Description1',
			link: 'Link1',
      pub_date: 'Thu, 25 Jul 2019 16:00:00 GMT' }
	end
	let(:set2) do
		{ title: 'Title2',
			description: 'Description2',
			link: 'Link2',
      pub_date: 'Thu, 25 Jul 2019 15:30:00 GMT' }
	end
	let(:set3) do
		{ title: 'Title3',
			description: 'Description3',
			link: 'Link3',
      pub_date: 'Thu, 25 Jul 2019 15:00:00 GMT' }
	end
	let(:set4) do
		{ title: 'Title4',
			description: 'Description4',
			link: 'Link4',
      pub_date: 'Thu, 25 Jul 2019 14:30:00 GMT' }
	end

  let(:body1) do
    '<?xml version="1.0" encoding="utf-8" ?> <rss version="2.0"'\
    ' xml:base="http://www.nasa.gov/" xmlns:atom="http://www.w3.org/2005/Atom"'\
    ' xmlns:dc="http://purl.org/dc/elements/1.1/"'\
    ' xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"'\
    ' xmlns:media="http://search.yahoo.com/mrss/">'\
    ' <channel> <title>NASA Breaking News</title>'\
    ' <link>http://www.nasa.gov/</link> <description>Hello there</description>'\
    " <item><title>#{set1[:title]}</title><description>#{set1[:description]}</description>"\
    " <link>#{set1[:link]}</link> <pubDate>#{set1[:pub_date]}</pubDate></item>"\
    " <item><title>#{set3[:title]}</title><description>#{set3[:description]}</description>"\
    " <link>#{set3[:link]}</link> <pubDate>#{set3[:pub_date]}</pubDate></item></channel></rss>"
  end

  let(:body2) do
    '<?xml version="1.0" encoding="utf-8" ?> <rss version="2.0"'\
    ' xml:base="http://www.nasa.gov/" xmlns:atom="http://www.w3.org/2005/Atom"'\
    ' xmlns:dc="http://purl.org/dc/elements/1.1/"'\
    ' xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"'\
    ' xmlns:media="http://search.yahoo.com/mrss/">'\
    ' <channel> <title>NASA Most Breaking News</title>'\
    ' <link>http://www.nasa.gov/</link> <description>Hello there</description>'\
    " <item><title>#{set2[:title]}</title><description>#{set2[:description]}</description>"\
    " <link>#{set2[:link]}</link> <pubDate>#{set2[:pub_date]}</pubDate></item>"\
    " <item><title>#{set4[:title]}</title><description>#{set4[:description]}</description>"\
    " <link>#{set4[:link]}</link> <pubDate>#{set4[:pub_date]}</pubDate></item></channel></rss>"
  end

  subject { described_class }

  before do
    stub_request(:get, "http://something.com/something.rss")
      .with(headers: {'Accept'=>'*/*',
                      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                     'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: body1, headers: {})

    stub_request(:get, "http://something.com/something-more.rss")
      .with(headers: { 'Accept'=>'*/*',
                      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                      'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: body2, headers: {})
  end

  describe '#perform' do
    it 'returns posts, ordered by their pub_date' do
      posts = subject.perform
      matching_array = [[set1[:title], set1[:pub_date]],
                        [set2[:title], set2[:pub_date]],
                        [set3[:title], set3[:pub_date]],
                        [set4[:title], set4[:pub_date]]]
      expect(posts.map { |post| [post.title, post.pub_date] }).to eq(matching_array)

      expect(posts.last.instance_values.symbolize_keys)
        .to eq({ title: set4[:title],
                 description: set4[:description],
                 link: set4[:link],
                 pub_date: Time.parse(set4[:pub_date]) })
    end
  end
end
