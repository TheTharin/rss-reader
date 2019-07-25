# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FeedForm, type: :model do
  describe 'validations' do
    subject { FeedForm.new }

    it { should validate_presence_of(:url) }
    it { should_not allow_value('blahblah').for(:url) }
    it { should allow_value('http://blahblah.net/something.html').for(:url) }
    it { should allow_value('http://www.something.com/something.rss').for(:url) }
    it { should allow_value('https://www.something.com/something.rss').for(:url) }
    it { should allow_value('https://www.something-very-long.com/something.rss').for(:url) }
    it { should allow_value('http://something.com/something.rss').for(:url) }
  end
end

