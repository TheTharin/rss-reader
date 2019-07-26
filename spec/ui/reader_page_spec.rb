require 'ui_spec_helper'
require './app/services/fetch_posts_service'

feature 'Reader', type: :feature do
  let(:base_page_object) { PageObjects::Base.new }
  let(:navigation_page_object) { PageObjects::Navigation.new }
  let(:reader_page_object) { PageObjects::Reader.new }

  let!(:feed1) do
    create(:feed, title: 'Hillarious title',
                  url: 'http://something.com/something-two.rss' )
  end

  let!(:posts) do
    posts = []

    (1..30).each do |number|
      posts << Post.new("Title#{number}",
                        'http://yahoo.com',
                        "Description#{number}",
                        Time.parse("Thu, #{number} Jul 2019 14:30:00 GMT"))
    end

    posts
  end

  before do
    allow(FetchPostsService).to receive(:perform).and_return(posts)
  end

  scenario 'check posts' do
    visit root_path
    navigation_page_object.click_on_reader
    reader_page_object.expect_to_have_posts(20)
    reader_page_object.click_on_second_page
    reader_page_object.expect_to_have_posts(10)
  end

  scenario 'click on a post title', js: true do
    visit root_path
    navigation_page_object.click_on_reader
    reader_page_object.click_on_first_title
    expect(page.windows.count).to eq 2
  end
end
