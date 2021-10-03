module FundProviders
  module XTrackers
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
          currency: overview_table.fetch('Share Class Currency'),
          residence: fetch_residence,
          tickers: fetch_tickers
        )
      end

      private

      def fetch_name
        find_text(css: '.heading-labeled h1')
      end

      def fetch_isin
        overview_table.fetch('ISIN')
      end

      def map_table_by_header
        pairs = find_elements(css: '#emea-pdp-container section h3, table').to_a
        result = {}
        h3 = nil
        table = nil
        until pairs.empty?
          element = pairs.shift

          if element.tag_name == 'h3'
            h3 = element
            table = nil
          elsif element.tag_name == 'table'
            table = element
          end

          result[h3.text.strip] = table if h3 && table
        end
        result
      end

      def tables
        @tables ||= map_table_by_header
      end

      def fetch_tickers
        tables.fetch('Ticker Symbols').find_elements(css: 'tbody tr').flat_map do |row|
          cols = row.find_elements(css: 'td')
          exchange_name = cols[0].text.strip
          currency = cols[2].text.strip

          {
            sedol: cols[1].text.strip,
            bloomberg: cols[3].text.strip,
            ric: cols[4].text.strip
          }.map do |kind, ticker|
            next if ticker.empty?

            ExchangeTicker.new(
              exchange_name: exchange_name,
              ticker: ticker,
              kind: kind,
              isin: fetch_isin,
              currency: currency
            )
          end
        end.compact
      end

      def fetch_description
        find_text(xpath: '/html/body/div[5]/section[2]/div[5]/div/div[1]/table/tbody/tr/td')
      rescue Selenium::WebDriver::Error::TimeoutError
        ''
      end

      def table_to_hash(css_class)
        build_kv("#{css_class} table tr", 'th', 'td')
      end

      def fetch_residence
        ISO3166::Country.find_country_by_name(overview_table.fetch('Fund Domicile')).alpha3
      end

      def summary
        @summary ||= build_kv('.product-box__container', 'small', 'p')
      end

      def overview_table
        @overview_table ||= table_to_hash('.internal-concept')
      end

      def fetch_provision
        overview_table.fetch('Fund All-In Fee (TER)')[2..-2].to_f / 100.0
      end

      def fetch_replication
        replication = overview_table.fetch('Investment Methodology')
        case replication
        when 'Direct Replication (physically)' then :physical
        when 'Indirect Replication (Swap)' then :synthetic
        else
          raise ServiceFailure, "Unsupported replication: #{replication}"
        end
      end

      def fetch_profit
        profit = summary['ACC'] || summary['PAY']

        case profit
        when 'Capitalizing' then :accumulated
        when 'Distributing' then :distributed
        else
          raise ServiceFailure, "Unsupported profit: #{profit}"
        end
      end

      def fetch_asset
        asset = summary['CO'] || summary['EQ'] || summary['MA'] || summary['FI']

        case asset
        when 'Equities' then :equity
        when 'Commodities' then :commodity
        when 'Multi Asset' then :multi_asset
        when 'Fixed Income' then :bonds
        else
          raise ServiceFailure, "Unsupported asset: #{asset}"
        end
      end
    end
  end
end
