module PageObjects
  class FeedForm < Base
    # Locator constants
    SAVE_BUTTON = 'input[type="submit"][value="Save"]'.freeze
    DANGER_ALERT = 'div[class="alert alert-danger"]'.freeze
    DELETE_BUTTON = 'a[data-method="delete"]'.freeze

    def click_on_cancel
      find("//a", :text => 'Cancel').click
    rescue Capybara::ElementNotFound
      raise 'Cancel button not found'
    end

    def click_on_save
      find_element_and_click(SAVE_BUTTON)
    rescue Capybara::ElementNotFound
      raise 'Save button not found'
    end

    def click_on_delete
      page.accept_confirm do
        find_element_and_click(DELETE_BUTTON)
      end
    rescue Capybara::ElementNotFound
      raise 'Delete button not found'
    end

    def fill_url(text)
      fill_in 'Url', with: text
    end

    def expect_to_have_danger_alert
      expect_to_have_css(DANGER_ALERT, 'Danger Alert is not Found')
    end

    def expect_to_have_hints(count)
      expect(page).to have_css('span[class="help-inline"]', :count => count)
    end
  end
end
