module FundProviders
  module Ishare
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
          currency: fetch_key_fact(:baseCurrencyCode),
          residence: fetch_residence,
          tickers: fetch_tickers
        )
      end

      private

      def fetch_key_fact(fact)
        find_text(css: ".col-#{fact} .data", timeout: 60)
      end

      def fetch_key_fact_symbol(fact)
        fetch_key_fact(fact)&.downcase&.parameterize(separator: '_')&.to_sym
      end

      def fetch_name
        find_text(css: '.main-header-holder .product-title')
      end

      def fetch_description
        find_text(css: '.fund-objective').gsub(/(INVESTMENT OBJECTIVE|ANLAGEZIEL)/, '').strip
      rescue Selenium::WebDriver::Error::TimeoutError
        ''
      end

      def click_on_listing_filters
        find_element(css: '.product-data-list .listingsTable .col-display-label').click
      end

      def listing_filter
        find_elements(css: '.product-data-list .listingsTable ul li').each_with_object({}) do |listing, result|
          result[listing.text] = listing.find_element(tag_name: 'input')
        end
      end

      def ensure_tickers_selected
        click_on_listing_filters
        [
          'SEDOL',
          'Ticker',
          'Bloomberg-Ticker',
          'RIC',
          'ISIN'
        ].each do |option|
          next unless listing_filter.key?(option)

          listing_filter[option].click unless listing_filter[option].attribute('checked') == 'true'
        end
        click_on_listing_filters
      end

      def fetch_tickers
        ensure_tickers_selected
        find_elements(css: '#listingsTable tbody tr').flat_map do |tr|
          exchange_name = tr.find_element(css: '.colExchange').text.strip
          currency = tr.find_element(css: '.colCurrencyCode').text.strip
          isin = tr.find_element(css: '.colIsin').text.strip

          {
            global: tr.find_element(css: '.colTicker').text.strip,
            sedol: tr.find_element(css: '.colSedol').text.strip,
            bloomberg: tr.find_element(css: '.colBBEQTICK').text.strip,
            ric: tr.find_element(css: '.colRic').text.strip
          }.map do |kind, ticker|
            next if ticker.size <= 1

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

      def fetch_asset
        asset = fetch_key_fact_symbol(:assetClass)

        case asset
        when :aktien then :equity
        when :equity then :equity
        when :bonds then :bonds
        when :anleihen then :bonds
        when :fixed_income then :bonds
        when :multi_asset then :multi_asset
        when :immobilien then :real_estate
        when :real_estate then :real_estate
        when :commodity then :commodity
        when :rohstoffe then :commodity
        else
          raise ServiceFailure, "Unknown asset code: #{asset}"
        end
      end

      def fetch_profit
        profit = fetch_key_fact_symbol(:useOfProfitsCode)

        case profit
        when :thesaurierend then :accumulated
        when :accumulating then :accumulated
        when :distributing then :distributed
        when :ausschuttend then :distributed
        when :keine_ertrage then :accumulated
        when :no_profit then :accumulated
        when :no_income then :accumulated
        else
          raise ServiceFailure, "Unknown profit code: #{profit}"
        end
      end

      def fetch_replication
        replication = fetch_key_fact_symbol(:productStructure)

        case replication
        when :physical then :physical
        when :synthetic then :synthetic
        when :physisch then :physical
        when :synthetisch then :synthetic
        else
          raise ServiceFailure, "Unsupported replication: #{replication}"
        end
      end

      def fetch_residence
        ISO3166::Country.find_country_by_name(fetch_key_fact(:domicile)).alpha3
      end

      def fetch_provision
        fetch_key_fact(:emeaMgt).to_f / 100.0
      end
    end
  end
end