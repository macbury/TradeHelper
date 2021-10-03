module FundProviders
  module Ishare
    # Fetch all etfs for iShare United Kingdom
    class FetchAllForCountry < BrowserService
      use AcceptTerms, as: :accept_terms

      def initialize(url:, **kwargs)
        super(**kwargs)
        @url = url
      end

      def call
        browser.get(url)

        accept_terms(browser)
        filter_only_etfs
        click_on_more

        funds.map { |a| build_etf_option(a) }
      end

      private

      attr_reader :url

      def funds
        @funds ||= find_elements(css: '.tb_fundNames')
      end

      def filter_only_etfs
        sleep 5
        find_elements(css: '.filter-button')[0].click
        sleep 1
        find_elements(css: '.popups-container .filter-group .radio')[1].click
        sleep 1
      end

      def click_on_more
        find_element(css: '.show-more-or-less button').click
      rescue Selenium::WebDriver::Error::ElementClickInterceptedError
        find_element(css: '.show-more-or-less button').click
      end

      def build_etf_option(a)
        PendingInstrument.new(
          symbol: a.find_element(css: '.localExchangeTicker').text,
          name: a.find_element(css: '.fundName').text,
          url: a.attribute(:href)
        )
      rescue Selenium::WebDriver::Error::TimeoutError
        nil
      end
    end
  end
end