module FundProviders
  module Vaneck
    class FetchDetails < BasicFetchDetails
      use AcceptTerms, as: :accept_terms
      use ProductIdentifier, as: :extract_product_identifier

      def call
        visit_page

        accept_terms(browser)

        InstrumentDetails.new(
          name: fetch_name,
          details_url: browser.current_url,
          product_identifier: extract_product_identifier(browser.current_url),
          description: fetch_description,
          asset: fetch_asset,
          profit: fetch_profit,
          replication: fetch_replication,
          provision: fetch_provision,
          currency: fund_info.fetch('Base Currency'),
          residence: fetch_residence,
          tickers: tickers
        )
      end

      private

      def fetch_trading_info_current_tab_options
        tab = find_elements(css: '.wi_tabs_table').find(&:displayed?)
        tab.find_elements(css: 'table tr').each_with_object({}) do |row, result|
          key, value = row.find_elements(tag_name: 'td')
          result[key.text.strip] = value.text.strip
        end
      end

      def tickers
        @tickers ||= find_elements(css: '.trading-info .tabs a').flat_map do |a|
          a.click

          exchange_parts = a.text.split("\n")
          exchange_name = exchange_parts.size == 3 ? exchange_parts[0..1].join(' ') : exchange_parts[0]
          options = fetch_trading_info_current_tab_options
          isin = options.fetch('ISIN')
          currency = options.fetch('Trading Currency')

          {
            global: options.fetch('Exchange Ticker'),
            bloomberg: options.fetch('Bloomberg'),
            sedol: options.fetch('SEDOL'),
            ric: options.fetch('Reuters (RIC)')
          }.map do |kind, ticker|
            next if ticker.size <= 2

            ExchangeTicker.new(
              exchange_name: exchange_name,
              ticker: ticker,
              kind: kind,
              isin: isin,
              currency: currency
            )
          end
        end.compact
      end

      def fetch_name
        find_text(css: '.fund-title')
      end

      def fetch_isin
        fund_info.fetch('ISIN')
      end

      def fetch_description
        find_text(css: '.text_mini_block p')
      end

      def fund_info
        @fund_info ||= build_kv('ul li', 'p', 'span')
      end

      def fetch_asset
        asset = pending_instrument.asset

        case asset
        when 'Equity' then :equity
        when 'bond' then :bonds
        else
          raise ServiceFailure, "Unknown asset code: #{asset}"
        end
      end

      def fetch_profit
        profit = fund_info.fetch('Income Treatment').strip

        case profit
        when 'Reinvestment' then :accumulated
        when 'Distributing' then :distributed
        else
          raise ServiceFailure, "Unknown profit code: #{profit}"
        end
      end

      def fetch_replication
        replication = fund_info.fetch('Product Structure')

        case replication
        when 'Physical (Full Replication)' then :physical
        when 'Physical (Optimized)' then :physical
        when 'Indirect (Swap Based)' then :synthetic
        else
          raise ServiceFailure, "Unsupported replication: #{replication}"
        end
      end

      def fetch_residence
        ISO3166::Country.find_country_by_name(fund_info.fetch('Domicile')).alpha3
      end

      def fetch_provision
        fund_info.fetch('Total Expense Ratio').to_f / 100.0
      rescue KeyError
        fund_info.fetch('Total Expense Ratio*').to_f / 100.0
      end
    end
  end
end