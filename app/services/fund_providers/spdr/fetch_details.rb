module FundProviders
  module Spdr
    class FetchDetails < BrowserService
      use AcceptTerms, as: :accept_terms
      use ProductIdentifier, as: :extract_product_identifier

      attr_reader :pending_instrument

      def initialize(pending_instrument:, **args)
        super(**args)
        @pending_instrument = pending_instrument
      end

      def call
        browser.get(pending_instrument.url)

        accept_terms(browser)

        InstrumentDetails.new(
          name: fetch_name,
          description: contents.fetch('Index Description'),
          provision: fetch_provision,
          residence: fetch_residence,
          currency: fund_information.fetch('CURRENCY'),
          details_url: browser.current_url,
          product_identifier: extract_product_identifier(browser.current_url),
          profit: fetch_profit,
          asset: fetch_asset,
          replication: fetch_replication,
          tickers: tickers
        )
      end

      private

      def fetch_name
        find_text(css: '.fund-detail-header h1 span')
      end

      def fetch_isin
        fund_information.fetch('ISIN')
      end

      def tickers
        @tickers ||= find_elements(css: '.emeaetflisting table.ssmp-d-mobile-none.ssmp-d-tablet-none tbody tr').flat_map do |row|
          cols = row.find_elements(css: 'td')

          exchange = cols[0].text.gsub('(Primary)', '').strip
          currency = cols[1].text.strip

          {
            global: cols[3].text.strip,
            sedol: cols[4].text.strip,
            bloomberg: cols[5].text.strip,
            ric: cols[6].text.strip,
          }.map do |kind, ticker|
            ExchangeTicker.new(
              exchange_name: exchange,
              ticker: ticker,
              kind: kind,
              isin: fetch_isin,
              currency: currency
            )
          end
        end
      end

      def details
        @details ||= build_kv('.aem-GridColumn .value', '.label', '.points')
      end

      def contents
        @contents ||= build_kv('.aem-GridColumn', 'h2', '.content')
      end

      def fund_information
        @fund_information ||= find_elements(css: '.table-items table').each_with_object({}) do |table, values|
          ths = table.find_elements(css: 'th')
          tds = table.find_elements(css: 'td')

          ths.each_with_index do |th, index|
            values[th.text.strip] = tds[index].text.strip
          end
        end
      end

      def fetch_asset
        asset = pending_instrument.asset

        case asset
        when 'Equity' then :equity
        when 'Fixed Income' then :bonds
        when 'Multi-Asset' then :multi_asset
        when 'Real Estate' then :real_estate
        else
          raise ServiceFailure, "Unknown asset code: #{asset}"
        end
      end

      def fetch_replication
        replication = fund_information.fetch('Replication Method')

        case replication
        when 'Replicated' then :physical
        when 'Stratified Sampling' then :physical
        when 'Optimised' then :physical
        else
          raise ServiceFailure, "Unknown replication code: #{replication}"
        end
      end

      def fetch_profit
        profit = fund_information.fetch('Income Treatment')

        case profit
        when 'Accumulation' then :accumulated
        when 'Distribution' then :distributed
        else
          raise ServiceFailure, "Unknown profit code: #{profit}"
        end
      end

      def fetch_residence
        ISO3166::Country.find_country_by_name(fund_information.fetch('Domicile')).alpha3
      end

      def fetch_provision
        fund_information.fetch('TER').to_f / 100.0
      end
    end
  end
end