module FundProviders
  module Spdr
    class AcceptTerms < Service
      include BrowserHelper

      attr_reader :browser

      def initialize(browser)
        @browser = browser
      end

      def call
        find_element(css: '.ssmp-self-identifier button.ssmp-ctalink__link').click
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        false
      end
    end
  end
end