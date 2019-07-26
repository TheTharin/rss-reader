module PageObjects
  class Base
    include Capybara::DSL
    include RSpec::Matchers

    def find_element_and_click(locator)
      find(locator).click
    end

    # check element existence
    def expect_to_have_css(locator, error_message)
      expect(page).to have_css(locator), error_message
    end
  end
end
