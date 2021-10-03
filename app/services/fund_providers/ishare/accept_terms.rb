module FundProviders
  module Ishare
    # Fetch all etfs for iShare United Kingdom
    class AcceptTerms < Service
      include BrowserHelper

      attr_reader :browser

      def initialize(browser)
        @browser = browser
      end

      def call
        sleep 5
        find_element(timeout: 30, css: '.accept-terms-condition-footer a').click
      rescue Selenium::WebDriver::Error::TimeoutError
        false
      end
    end
  end
end