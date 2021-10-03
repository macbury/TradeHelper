module FundProviders
  module Vaneck
    class FetchAll < BrowserService
      URL = 'https://www.vaneck.com/uk/en/performance/navs/'.freeze
      use AcceptTerms, as: :accept_terms

      def call
        browser.get(URL)

        accept_terms(browser)

        wait_for_table

        instruments = []

        each_asset('Equity') { |equity| instruments << equity }
        each_bond { |bond| instruments << bond }

        instruments
      end

      private

      def wait_for_table
        find_element(css: '.MainBlock', timeout: 60)
      end

      def each_asset(asset)
        find_elements(css: '.fund_returns_table_prices_etf tr.dotwrap td:first-child a').each do |a|
          yield PendingInstrument.new(
            name: a.text,
            url: a.attribute(:href),
            asset: asset
          )
        end
      end

      def each_bond(&block)
        find_elements(css: '.tabNavigation a')[1].click
        each_asset('bond', &block)
      end
    end
  end
end