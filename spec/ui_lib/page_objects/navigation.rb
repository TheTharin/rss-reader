module PageObjects
  class Navigation < Base
    # Locator constants
    MENU_FEEDS = 'a[href="/feeds"]'
    MENU_READER = 'a[href="/reader"]'

    def click_on_feeds
      find_element_and_click(MENU_FEEDS)
    rescue Capybara::ElementNotFound
      raise 'No Feeds button in menu'
    end

    def click_on_reader
      find_element_and_click(MENU_READER)
    rescue Capybara::ElementNotFound
      raise 'No Reader button in menu'
    end
  end
end
