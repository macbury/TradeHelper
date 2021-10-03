module FundProviders
  module WisdomTree
    class FetchAll < BrowserService
      URL = 'https://www.wisdomtree.eu/en-gb/products'.freeze
      ASSET_CLASS_OPTION = [
        'Alternatives',
        'Currencies',
        'Commodities',
        'Equities',
        'Fixed Income',
        'Digital Assets'
      ].freeze

      use AcceptTerms, as: :accept_terms

      def call
        browser.get(URL)

        accept_terms(browser)
        # select_etfs

        etfs = []
        each_funds do |a, asset_class|
          etfs << build_etf_option(a, asset_class)
        end
        etfs
      end

      private

      def select_etfs
        filters['All Structures'].send_keys 'ETF'
        sleep 2
        filters['All Structures'].send_keys :return
      end

      def filters
        @filters ||= find_elements(css: '.fund-btn-group').each_with_object({}) do |filter, result|
          result[filter.text] = filter.find_element(tag_name: 'input')
        end
      end

      def each_funds
        filter = filters['All Asset Classes']

        ASSET_CLASS_OPTION.each do |asset_class|
          filter.send_keys asset_class
          sleep 5
          filter.send_keys '', :return
          sleep 5
          find_elements(css: 'table tr .nameLink a').each do |a|
            yield a, asset_class
          end
          filter.send_keys '', :backspace
          sleep 5
        end
      end

      def build_etf_option(a, asset_class)
        PendingInstrument.new(
          name: a.text,
          url: a.attribute(:href),
          asset: asset_class
        )
      rescue Selenium::WebDriver::Error::TimeoutError
        nil
      end
    end
  end
end