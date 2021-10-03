module FundProviders
  module Lyxor
    class FetchAllForPl < BrowserService
      PL_URL = 'https://www.lyxoretf.pl/pl/retail/products/search/equity-etf'.freeze
      use AcceptTerms, as: :accept_terms

      def call
        browser.get(PL_URL)

        accept_terms(browser)
        funds.map { |tr| build_etf_option(tr, 'Equity') }
      end

      private

      def funds
        find_elements(css: '.ui-datatable-tablewrapper table tbody tr')
      end

      def build_etf_option(tr, asset)
        cols = tr.find_elements(tag_name: 'td')

        a = cols[1].find_element(tag_name: 'a')
        symbol = cols[0].text
        isin = cols[3].text

        PendingInstrument.new(
          name: a.text,
          url: a.attribute(:href),
          asset: asset,
          symbol: symbol,
          isin: isin
        )
      rescue Selenium::WebDriver::Error::TimeoutError
        nil
      end
    end
  end
end