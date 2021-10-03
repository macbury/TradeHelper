module FundProviders
  module Lyxor
    class FetchAll < Service
      UK_PUB_URL = 'https://www.lyxoretf.co.uk/en/retail/products/search/equity-etf'.freeze
      UK_PRO_URL = 'https://www.lyxoretf.co.uk/en/instit/products/search/equity-etf'.freeze
      LU_URL = 'https://www.lyxoretf.lu/en/retail/products/search/equity-etf'.freeze

      use FetchAllForCountry, as: :fetch_all_for_country
      use FetchAllForPl, as: :fetch_all_for_pl

      def call
        indexed_etfs = uk_public_pending_efts
        indexed_etfs += filter_etfs(indexed_etfs, uk_pro_pending_etfs)
        indexed_etfs += fetch_all_for_pl
        indexed_etfs += broken_etfs
        indexed_etfs += filter_etfs(indexed_etfs, lu_pending_etfs)
        indexed_etfs
      end

      private

      def filter_etfs(indexed_etfs, pending_etfs)
        pending_etfs.reject { |pending_etf| indexed_etfs.any? { |indexed_etf| indexed_etf.isin == pending_etf.isin } }
      end

      def uk_public_pending_efts
        @uk_public_pending_efts ||= fetch_all_for_country(url: UK_PUB_URL)
      end

      def lu_pending_etfs
        @lu_pending_etfs ||= fetch_all_for_country(url: LU_URL)
      end

      def uk_pro_pending_etfs
        @uk_pro_pending_etfs ||= fetch_all_for_country(url: UK_PRO_URL)
      end

      # for some reason the do not appear normally
      def broken_etfs
        [
          PendingInstrument.new(
            name: 'Lyxor S&P 500 VIX Futures Enhanced Roll UCITS ETF - Acc',
            url: 'https://www.lyxoretf.co.uk/en/instit/products/alternatives/lyxor-sp-500-vix-futures-enhanced-roll-ucits-etf-acc/lu0832435464/eur',
            asset: 'Equity',
            symbol: 'LVO',
            isin: 'LU0832435464'
          )
        ]
      end
    end
  end
end