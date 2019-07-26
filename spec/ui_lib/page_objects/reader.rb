module PageObjects
  class Reader < Base
    # Locator constants
    SECOND_PAGE_LINK = 'a[href="/?page=2"]'
    POST_TITLE = 'a[class="title-text"]'

    def click_on_second_page
      find(SECOND_PAGE_LINK, match: :first).click
    rescue Capybara::ElementNotFound
      raise 'Second page not found'
    end

    def click_on_first_title
      find(POST_TITLE, match: :first).click
    rescue Capybara::ElementNotFound
      raise 'Second page not found'
    end

    def expect_to_have_posts(count)
      expect(page).to have_css('div[class="media mt-3 border-bottom"]', :count => count)
    end
  end
end
