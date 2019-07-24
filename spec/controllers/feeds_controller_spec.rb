# frozen_string_literal: true

require 'spec_helper'

describe FeedsController, type: :controller do
  let(:body1) do
    '<?xml version="1.0" encoding="utf-8" ?> <rss version="2.0"'\
    ' xml:base="http://www.nasa.gov/" xmlns:atom="http://www.w3.org/2005/Atom"'\
    ' xmlns:dc="http://purl.org/dc/elements/1.1/"'\
    ' xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"'\
    ' xmlns:media="http://search.yahoo.com/mrss/">'\
    ' <channel> <title>NASA Breaking News</title>'\
    ' <link>http://www.nasa.gov/</link> <description>Hello there</description></channel> </rss>'
  end

  let(:body2) do
    '<?xml version="1.0" encoding="utf-8" ?> <rss version="2.0"'\
    ' xml:base="http://www.nasa.gov/" xmlns:atom="http://www.w3.org/2005/Atom"'\
    ' xmlns:dc="http://purl.org/dc/elements/1.1/"'\
    ' xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"'\
    ' xmlns:media="http://search.yahoo.com/mrss/">'\
    ' <channel> <title>NASA Most Breaking News</title>'\
    ' <link>http://www.nasa.gov/</link> <description>Hello there</description></channel> </rss>'
  end

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

    stub_request(:get, "http://something.com/bad.rss")
      .with(headers: { 'Accept'=>'*/*',
                      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                      'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: '', headers: {})
  end

  describe 'POST #create' do
    context 'when url is valid' do
      it 'creates a new Feed and redirects to edit_admin_user_path' do
        post :create, params: { feed: { url: 'http://something.com/something.rss' } }

        expect(Feed.count).to eq(1)
        expect(Feed.last.url).to eq('http://something.com/something.rss')
        expect(Feed.last.title).to eq('NASA Breaking News')
        expect(response).to redirect_to feeds_path
      end
    end

    context 'when url is invalid' do
      it 'doesnt create a Feed' do
        post :create, params: { feed: { url: 'http://something.com/bad.rss' } }
        expect(Feed.count).to eq(0)
      end
    end
  end

  describe 'PUT #update' do
    let(:feed) { create(:feed, url: 'http://something.com/something.rss',
                               title: 'NASA Breaking News') }
    context 'when url is valid' do
      let(:new_url) { 'http://something.com/something-more.rss' }

      it 'updates a Feed and redirects to feed edit path' do
        put :update, params: { id: feed.id, feed: { url: new_url } }

        expect(Feed.find(feed.id).url).to eq(new_url)
        expect(Feed.find(feed.id).title).to eq('NASA Most Breaking News')
        expect(response).to redirect_to feeds_path
      end
    end

    context 'when url is invalid' do
      let(:new_url) { 'bad_url' }

      it 'doesnt update the Feed and renders edit template' do
        put :update, params: { id: feed.id, feed: { url: new_url } }

        expect(Feed.find(feed.id).title).to eq('NASA Breaking News')
        expect(response).to render_template(:edit)
      end
    end
  end
end
