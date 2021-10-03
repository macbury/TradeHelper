module FundProviders
  module WisdomTree
    class FetchDetails < BasicFetchDetails
      use AcceptTerms, as: :accept_terms
      use ProductIdentifier, as: :extract_product_identifier

      def call
        visit_page

        accept_terms(browser)
        accept_risk
        sleep 5

        InstrumentDetails.new(
          name: fetch_name,
          details_url: browser.current_url,
          product_identifier: extract_product_identifier(browser.current_url),
          description: fetch_description,
          asset: fetch_asset,
          profit: fetch_profit,
          replication: fetch_replication,
          provision: fetch_provision,
          currency: fetch_currency,
          residence: fetch_residence,
          tickers: fetch_tickers
        )
      end

      private

      def fund_overview
        @fund_overview ||= build_kv('table.fund-overview tr', 'td.key', 'td.value')
      end

      def accept_risk
        find_element(id: 'acknowledgements-accept', timeout: 10).click
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        nil
      end

      def fetch_name
        find_text(css: '.fund-name')
      end

      def fetch_description
        find_text(css: '.fund-header-description')
      rescue Selenium::WebDriver::Error::TimeoutError
        ''
      end

      def fetch_asset
        asset = pending_instrument.asset

        case asset
        when 'Commodities' then :commodity
        when 'Currencies' then :bonds
        when 'Equities' then :equity
        when 'Alternatives' then :equity
        when 'Digital Assets' then :commodity
        when 'Fixed Income' then :bonds
        else
          raise ServiceFailure, "Unknown asset code: #{asset}"
        end
      end

      def fetch_replication
        replication = fund_overview.fetch('Replication Method', fund_overview.fetch('Replication method', nil))

        case replication
        when 'Physical - backed by Bitcoin' then :physical
        when 'Physical - backed by bullion' then :physical
        when 'Physical, Fully Replicated' then :physical
        when 'Physical (optimised)' then :physical
        when 'Fully Collaterised Swap' then :synthetic
        when 'US TBills With Swap Overlay' then :synthetic
        when 'Synthetic - fully funded collateralised swap' then :synthetic
        when 'Synthetic - unfunded swap backed by collateral' then :synthetic
        else
          raise ServiceFailure, "Unknown replication code: #{replication}"
        end
      end

      def fetch_profit
        profit = fund_overview.fetch('Use of Income', 'accumulated').strip

        case profit
        when 'accumulated' then :accumulated
        when 'Accumulating' then :accumulated
        when 'Distributing' then :distributed
        else
          raise ServiceFailure, "Unknown profit code: #{profit}"
        end
      end

      def fetch_provision
        fund_overview.fetch('TER', fund_overview.fetch('MER', nil)).to_f / 100.0
      end

      def fetch_currency
        fund_overview.fetch('Base Currency')
      rescue KeyError
        fund_overview.fetch('Base/Trading Currency').split('/')[0]
      end

      def fetch_residence
        ISO3166::Country.find_country_by_name(fund_overview.fetch('Domicile')).alpha3
      end

      def parse_table(table_query)
        table = find_element(css: table_query)
        keys = table.find_elements(css: 'thead th').map(&:text)

        table.find_elements(css: 'tbody tr').map do |tr|
          cols = tr.find_elements(tag_name: 'td')
          result = {}
          cols.each_with_index do |col, index|
            result[keys[index]] = col.text
          end
          result
        end
      end

      def fetch_tickers
        parse_table('#fund-listing-codes table.visible-lg').flat_map do |row|
          exchange = row.fetch('Exchange').strip
          currency = row.fetch('Trading Currency').strip
          isin = row.fetch('ISIN').strip

          {
            global: row.fetch('Exchange Ticker').strip,
            bloomberg: row.fetch('Bloomberg Ticker', '').strip,
            ric: row.fetch('Reuters Instrument Code', '').strip,
            sedol: row.fetch('SEDOL', '').strip
          }.map do |kind, ticker|
            next if ticker.empty?

            ExchangeTicker.new(
              exchange_name: exchange,
              ticker: ticker,
              kind: kind,
              isin: isin,
              currency: currency
            )
          end
        end.compact
      end
    end
  end
end