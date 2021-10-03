module FundProviders
  module Vanguard
    class FetchDetails < BasicFetchDetails
      ACCUMULATION_PROFIT = /Accumulation share class reinvests its dividends/i.freeze
      use ProductIdentifier, as: :extract_product_identifier
      use FetchIsin, as: :fetch_isin

      def call
        visit_page

        InstrumentDetails.new(
          name: pending_instrument.name,
          details_url: browser.current_url,
          product_identifier: extract_product_identifier(browser.current_url),
          description: fetch_description,
          asset: fetch_asset,
          profit: fetch_profit,
          replication: fetch_replication,
          provision: fetch_provision,
          currency: fetch_currency,
          residence: fetch_residence,
          tickers: tickers
        )
      end

      def fetch_name
        to_remove = find_text(css: '#fundsName span')
        find_text(css: '#fundsName').gsub(to_remove, '').strip
      end

      def fetch_description
        find_text(css: '.investmentObjective')
      end

      def fetch_provision
        find_text(id: 'annualFee').to_f / 100.0
      end

      def fetch_currency
        find_text(css: '.currency').gsub(/[^A-Z]/i, '')
      end

      def fetch_residence
        residence = find_text(css: '.taxStatus span')

        case residence
        when 'Germany, UK Reporting' then 'IRL'
        when 'UK Reporting' then 'IRL'
        when 'Austria, Germany, Switzerland, and UK Reporting' then 'IRL'
        else
          raise ServiceFailure, "Unknown residence: #{residence}"
        end
      end

      def fetch_accumulation
        return :accumulated if find_elements(css: '.vuiMsgBox', timeout: 1).any? { |div| div.text.match(ACCUMULATION_PROFIT) }
      rescue Selenium::WebDriver::Error::TimeoutError
        nil
      end

      def fetch_profit
        find_element(link_text: 'Distributions').click
        sleep 3

        return fetch_accumulation if fetch_accumulation

        profit = find_text(css: '.fundDistributionType', timeout: 1)

        case profit
        when 'Income Distribution' then :distributed
        else
          raise ServiceFailure, "Unknown profit code: #{profit}"
        end
      ensure
        find_element(link_text: 'Overview').click
      end

      def fetch_asset
        asset = find_text(id: 'assetClass')

        case asset
        when 'Bond' then :bonds
        when 'Equity' then :equity
        else
          raise ServiceFailure, "Unknown asset code: #{asset}"
        end
      end

      def fetch_replication
        asset = fetch_asset

        case asset
        when :bonds then :physical
        when :equity then :physical
        else
          raise ServiceFailure, "Unknown replication for asset: #{asset}"
        end
      end

      def tickers
        ticker = find_text(css: 'h1.banner span:last-child').gsub(/[^A-Z]/i, '')

        [
          ExchangeTicker.new(
            exchange_name: 'LSE',
            ticker: ticker,
            kind: :global,
            isin: fetch_isin(browser: browser),
            currency: fetch_currency
          )
        ]
      end
    end
  end
end