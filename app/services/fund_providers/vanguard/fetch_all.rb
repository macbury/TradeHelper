module FundProviders
  module Vanguard
    class FetchAll < BrowserService
      URL = 'https://www.vanguardinvestor.co.uk/what-we-offer/etf-products'.freeze

      def call
        browser.get(URL)

        sleep 30
        funds.map do |a|
          build_etf_option(a)
        end
      end

      private

      def funds
        @funds ||= find_elements(css: '.fundName .value a.linkMargin').reject { |a| a.text.empty? }
      end

      def build_etf_option(a)
        PendingInstrument.new(
          name: a.text,
          url: a.attribute(:href)
        )
      rescue Selenium::WebDriver::Error::TimeoutError
        nil
      end
    end
  end
end