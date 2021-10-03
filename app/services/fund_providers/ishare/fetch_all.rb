module FundProviders
  module Ishare
    # Fetch all etfs for iShare
    class FetchAll < Service
      UK_URL = 'https://www.ishares.com/uk/individual/en/products/etf-investments'.freeze
      DE_URL = 'https://www.ishares.com/de/privatanleger/de/produkte/etf-investments'.freeze
      CH_URL = 'https://www.ishares.com/ch/individual/en/products/etf-investments'.freeze

      use FetchAllForCountry, as: :fetch_all_for

      def call
        [
          de_pending_etfs.reject { |pending_etf| uk_and_ch_symbols.include?(pending_etf.symbol) },
          ch_pending_etfs.reject { |pending_etf| uk_symbols.include?(pending_etf.symbol) },
          uk_pending_efts
        ].flatten
      end

      private

      def uk_pending_efts
        @uk_pending_efts ||= fetch_all_for(url: UK_URL)
      end

      def de_pending_etfs
        @de_pending_etfs ||= fetch_all_for(url: DE_URL)
      end

      def ch_pending_etfs
        @ch_pending_etfs ||= fetch_all_for(url: CH_URL)
      end

      def uk_symbols
        @uk_symbols ||= uk_pending_efts.map(&:symbol)
      end

      def uk_and_ch_symbols
        @uk_and_ch_symbols ||= uk_symbols + ch_pending_etfs.map(&:symbol)
      end
    end
  end
end