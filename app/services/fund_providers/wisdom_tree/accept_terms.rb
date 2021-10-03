module FundProviders
  module WisdomTree
    # Fetch all etfs for iShare United Kingdom
    class AcceptTerms < Service
      include BrowserHelper

      attr_reader :browser

      def initialize(browser)
        @browser = browser
      end

      def call
        find_element(css: '.nav-tabs li:last-child a').click
        find_element(id: 'accept-terms-btn').click
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        false
      end
    end
  end
end