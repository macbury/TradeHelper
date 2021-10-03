module FundProviders
  module XTrackers
    # Fetch all etfs for iShare United Kingdom
    class AcceptTerms < Service
      include BrowserHelper

      attr_reader :browser

      def initialize(browser)
        @browser = browser
      end

      def call
        accept_terms
        accept_cookies
      end

      private

      def accept_cookies
        find_element(css: '.btn-accept').click
      rescue Selenium::WebDriver::Error::TimeoutError
      end

      def accept_terms
        find_element(css: '.audience-selection__item:first-child').click
        find_element(link_text: 'Accept').click
      rescue Selenium::WebDriver::Error::TimeoutError
      end
    end
  end
end