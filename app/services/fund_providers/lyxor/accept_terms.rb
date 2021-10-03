module FundProviders
  module Lyxor
    # Fetch all etfs for iShare United Kingdom
    class AcceptTerms < Service
      include BrowserHelper

      attr_reader :browser

      def initialize(browser)
        @browser = browser
      end

      def call
        accept_cookies

        accept_terms_uk || accept_terms_lu
      end

      private

      def professional?
        browser.current_url.match(/instit/)
      end

      def individual?
        browser.current_url.match(/retail/)
      end

      def accept_terms_uk
        find_element(css: '.disclaimerCheckbox').click

        if professional?
          uk_buttons.fetch('I am a professional investor').click
        elsif individual?
          uk_buttons.fetch('I am a private investor').click
        else
          raise ServiceFailure, "Not supported type of terms: #{browser.current_url}"
        end
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        false
      end

      def accept_terms_lu
        disclaimer_buttons&.fetch('Institutional', nil)&.click
        disclaimer_buttons&.fetch('Inwestor indywidualny', nil)&.click
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        false
      end

      def accept_cookies
        find_element(css: '#CookiesDisclaimerRibbonV1-AllOn').click
        sleep 1
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        false
      end

      def disclaimer_buttons
        find_elements(css: '#disclaimerButton button').index_by(&:text)
      rescue Selenium::WebDriver::Error::TimeoutError
        {}
      end

      def uk_buttons
        find_elements(css: '.menuBoutonDisclaimer').index_by(&:text)
      rescue Selenium::WebDriver::Error::TimeoutError
        {}
      end
    end
  end
end