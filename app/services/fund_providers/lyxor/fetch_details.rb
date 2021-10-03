module FundProviders
  module Lyxor
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
          currency: fetch_currency,
          residence: fetch_residence,
          tickers: tickers
        )
      end

      private

      def fetch_name
        find_text(css: '#m-product-sticky-trigger h1')
      end

      def fetch_description
        show_more_description
        find_text(css: '.m-redmore')
      end

      def show_more_description
        find_element(css: '.show_hide').click
      rescue Selenium::WebDriver::Error::ElementClickInterceptedError, Selenium::WebDriver::Error::TimeoutError
      end

      def fetch_currency
        fund_info.fetch('Share Class Currency', nil) || fund_info.fetch('Waluta księgowa')
      end

      def fund_info
        @fund_info ||= build_kv('table tr', 'td:first-child', 'td:last-child')
      end

      def trading_information
        @trading_information ||= find_elements(css: '.index-information-wrapper tbody tr').each_with_object({}) do |tr, result|
          columns = tr.find_elements(css: 'td')
          isin = columns[7].text.strip

          result[isin] = {
            isin: isin,
            kind: :bloomberg,
            ticker: columns[1].text.strip,
            currency: columns[2].text.strip,
            exchange_name: columns[0].text.strip
          }
        end
      end

      def tickers
        isin = fund_info.fetch('ISIN')

        bloomberg_ticker = ExchangeTicker.new(trading_information[isin])
        global_ticker = ExchangeTicker.new(
          exchange_name: bloomberg_ticker.exchange_name,
          ticker: find_text(css: '#m-product-sticky-trigger span'),
          kind: :global,
          isin: isin,
          currency: fetch_currency
        )

        [
          bloomberg_ticker,
          global_ticker
        ]
      end

      def fetch_asset
        asset = pending_instrument.asset

        case asset
        when 'Equity' then :equity
        when 'Fixed Income' then :bonds
        when 'Commodities' then :commodity
        else
          raise ServiceFailure, "Unknown asset code: #{asset}"
        end
      end

      def fetch_profit
        profit = fund_info.fetch('Dividend Treatment', nil) || fund_info.fetch('Akumulacja/Dystrybucja')

        case profit
        when 'Capitalisation' then :accumulated
        when 'Distribution' then :distributed
        when 'Akumulacja' then :accumulated
        when 'Dystrybucja' then :distributed
        else
          raise ServiceFailure, "Unknown profit code: #{profit}"
        end
      end

      def fetch_replication
        replication = fund_info.fetch('Replication Method', nil) || fund_info.fetch('Metoda replikacji')

        case replication
        when 'Direct (Physical)' then :physical
        when 'Indirect (Swap Based)' then :synthetic
        when 'Replikacja syntetyczna (swapowa)' then :synthetic
        when 'Replikacja pełna (fizyczna)' then :physical
        else
          raise ServiceFailure, "Unsupported replication: #{replication}"
        end
      end

      def fetch_residence
        domicile = fund_info.fetch('Domicile', nil) || fund_info.fetch('Domicyl')

        case domicile
        when 'Luksemburg' then ISO3166::Country.find_country_by_name('luxemburg').alpha3
        else
          ISO3166::Country.find_country_by_name(domicile).alpha3
        end
      end

      def fetch_provision
        (fund_info.fetch('Total Expense Ratio', nil) || fund_info.fetch('TER*')).to_f / 100.0
      end
    end
  end
end