source 'https://rubygems.org'
ruby '2.6.2'

source 'https://rubygems.org'

gem 'rails', '~> 5.2.3'
gem 'sqlite3'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'bootsnap', '>= 1.1.0'
gem 'rss'

# prettier than HAML
gem 'slim-rails'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'puma', '~> 3.11'
  gem 'rubocop', '~> 0.63.1'
end

group :test, :development do
  gem 'rspec-rails'

  gem 'pry-rails'
  gem 'pry-theme'
  gem 'byebug'

  gem 'factory_girl_rails'
  gem 'webmock'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
