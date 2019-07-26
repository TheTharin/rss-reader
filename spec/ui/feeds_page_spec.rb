require 'ui_spec_helper'

feature 'Feeds', type: :feature do
  let(:base_page_object) { PageObjects::Base.new }
  let(:navigation_page_object) { PageObjects::Navigation.new }
  let(:feeds_page_object) { PageObjects::Feeds.new }
  let(:feed_form_page_object) { PageObjects::FeedForm.new }

  let!(:feed1) do
    create(:feed, title: 'Hillarious title',
                  url: 'http://something.com/something-two.rss' )
  end
  let!(:feed2) do
		create(:feed, title: 'Brilliant title',
                  url: 'http://something.com/something-more-two.rss' )
	end

  let(:body) do
    '<?xml version="1.0" encoding="utf-8" ?> <rss version="2.0"'\
    ' xml:base="http://www.nasa.gov/" xmlns:atom="http://www.w3.org/2005/Atom"'\
    ' xmlns:dc="http://purl.org/dc/elements/1.1/"'\
    ' xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"'\
    ' xmlns:media="http://search.yahoo.com/mrss/">'\
    ' <channel> <title>NASA Most Breaking News</title>'\
    ' <link>http://www.nasa.gov/</link> <description>Hello there</description></channel></rss>'
  end

  before do
    stub_request(:get, "http://something.com/something-more-three.rss")
      .with(headers: { 'Accept'=>'*/*',
                      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                      'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: body, headers: {})

    stub_request(:get, "kek")
      .with(headers: { 'Accept'=>'*/*',
                      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                      'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: '', headers: {})

    stub_request(:get, "http://yahoo.com")
      .with(headers: { 'Accept'=>'*/*',
                      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                      'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: '', headers: {})
  end

  scenario 'check feeds page structure' do
    visit feeds_path
    feeds_page_object.expect_to_have_edit_feed_button(feed1.id)
    feeds_page_object.expect_to_have_edit_feed_button(feed2.id)
    feeds_page_object.expect_to_have_delete_feed_button(feed1.id)
    feeds_page_object.expect_to_have_delete_feed_button(feed2.id)
    feeds_page_object.expect_to_have_new_feed_button
    feeds_page_object.expect_to_have_feeds(2)
  end

  describe 'creating new feed process' do
    context 'when valid url is provided' do
      it 'creates new feed' do
        visit feeds_path
        feeds_page_object.click_on_new_feed
        feed_form_page_object.fill_url('http://something.com/something-more-three.rss')
        feed_form_page_object.click_on_save
        feeds_page_object.expect_to_have_success_notice
        feeds_page_object.expect_to_have_feeds(3)
      end
    end

    context 'when invalid url is provided' do
      it 'doesnt create new feed' do
        visit feeds_path
        feeds_page_object.click_on_new_feed
        feed_form_page_object.fill_url('kek')
        feed_form_page_object.click_on_save
        feed_form_page_object.expect_to_have_danger_alert
        feed_form_page_object.expect_to_have_hints(2)
        feed_form_page_object.fill_url('http:/yahoo.com')
        feed_form_page_object.click_on_save
        feed_form_page_object.expect_to_have_danger_alert
        feed_form_page_object.expect_to_have_hints(1)
        feed_form_page_object.click_on_cancel
        feeds_page_object.expect_to_have_feeds(2)
      end
    end
  end

  describe 'editing new feed process' do
    context 'when valid url is provided' do
      it 'edits feed' do
        visit feeds_path
        feeds_page_object.click_on_edit_feed(feed1.id)
        feed_form_page_object.fill_url('http://something.com/something-more-three.rss')
        feed_form_page_object.click_on_save
        feeds_page_object.expect_to_have_success_notice
        feeds_page_object.expect_to_have_feed_with_title('NASA Most Breaking News')
        feeds_page_object.expect_to_have_feeds(2)
      end
    end

    context 'when invalid url is provided' do
      it 'doesnt create new feed' do
        visit feeds_path
        feeds_page_object.click_on_edit_feed(feed1.id)
        feed_form_page_object.fill_url('kek')
        feed_form_page_object.click_on_save
        feed_form_page_object.expect_to_have_hints(2)
        feed_form_page_object.click_on_cancel
        feeds_page_object.expect_to_have_feed_with_title(feed1.title)
        feeds_page_object.expect_to_have_feed_with_title(feed2.title)
        feeds_page_object.expect_to_have_feeds(2)
      end
    end

    context 'delete button pressed' do
      it 'doesnt create new feed', :js => true do
        visit feeds_path
        feeds_page_object.click_on_edit_feed(feed1.id)
        feed_form_page_object.click_on_delete
        feeds_page_object.expect_to_have_success_notice
        feeds_page_object.expect_to_have_feeds(1)
      end
    end
  end

  describe 'deleting feed from index' do
    it 'doesnt create new feed', :js => true do
      visit feeds_path
      feeds_page_object.click_on_delete_feed(feed1.id)
      feeds_page_object.expect_to_have_success_notice
      feeds_page_object.expect_to_have_feeds(1)
    end
  end
end
