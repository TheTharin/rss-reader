module PageObjects
  class Feeds < Base
    # Locator constants
    NEW_FEED_BUTTON = 'a[href="/feeds/new"]'.freeze
    SUCCESS_NOTICE = 'div[class="alert alert-success"]'.freeze
    FEED_TITLE_LOCATOR = 'tbody td'

    def click_on_new_feed
      find_element_and_click(NEW_FEED_BUTTON)
    rescue Capybara::ElementNotFound
      raise 'Add new feed button not found'
    end

    def click_on_edit_feed(id)
      find_element_and_click(edit_feed_button(id))
    rescue Capybara::ElementNotFound
      raise 'Add new feed button not found'
    end

    def click_on_delete_feed(id)
      page.accept_confirm do
        find_element_and_click(delete_feed_button(id))
      end
    rescue Capybara::ElementNotFound
      raise 'Delete button not found'
    end

    def expect_to_have_edit_feed_button(id)
      expect_to_have_css(edit_feed_button(id), 'Edit Feed button not found')
    end

    def expect_to_have_new_feed_button
      expect_to_have_css(NEW_FEED_BUTTON, 'New Feed button not found')
    end

    def expect_to_have_delete_feed_button(id)
      expect_to_have_css(delete_feed_button(id), 'Delete Feed button not found')
    end

    def expect_to_have_success_notice
      expect_to_have_css(SUCCESS_NOTICE, 'Feed havent been created')
    end

    def expect_to_have_feed_with_title(title)
      expect(page).to have_css(FEED_TITLE_LOCATOR, text: title), 'Feed with title not found'
    end

    def expect_to_have_feeds(count)
      expect(page).to have_css('tbody tr', :count => count)
    end

    private

    def edit_feed_button(id)
      "a[href=\"/feeds/#{id}/edit\"]"
    end

    def delete_feed_button(id)
      "a[data-method=\"delete\"][href=\"/feeds/#{id}\"]"
    end
  end
end
