module FundProviders
  module Spdr
    class FetchAll < BrowserService
      use AcceptTerms, as: :accept_terms
      URL = 'https://www.ssga.com/uk/en_gb/institutional/etfs/fund-finder'.freeze

      def call
        browser.get(URL)
        accept_terms(browser)

        wait_for_funds

        all = []

        each_asset do |asset|
          all += funds.map { |a| build_etf_option(a, asset) }
        end

        all
      end

      private

      def funds
        find_elements(timeout: 60, css: 'table .fundName a')
      end

      def wait_for_funds
        funds
      end

      def each_asset
        sleep 1
        find_elements(timeout: 60, css: '.filters-main > .filters-list > .cate-level-1').first.click

        find_elements(css: '.cate-level-1')[0].find_elements(css: '.cate-level-2 > span').each do |asset|
          asset.click
          sleep 1
          yield asset.text.strip
          sleep 1
          asset.click
        end
      end

      def build_etf_option(a, asset)
        PendingInstrument.new(
          name: a.text,
          url: a.attribute(:href),
          asset: asset
        )
      rescue Selenium::WebDriver::Error::TimeoutError
        nil
      end
    end
  end
end