module FundProviders
  module Vaneck
    # Fetch all etfs for iShare United Kingdom
    class AcceptTerms < Service
      include BrowserHelper

      attr_reader :browser

      def initialize(browser)
        @browser = browser
      end

      def call
        sleep 5
        find_element(timeout: 30, css: '.investortype button.btn').click
        find_elements(css: 'ul.investortype a')[0].click
        find_element(id: 'btnAgree').click
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        false
      end
    end
  end
end