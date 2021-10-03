# https://bossa.pl/oferta/rynek-zagraniczny/kid
module Brokers
  module Instruments
    module Fetch
      class Bossa < BrowserService
        URL = 'https://bossa.pl/oferta/rynek-zagraniczny/kid'.freeze

        def call
          Rails.cache.fetch('brokers/bossa/pending_instruments', expires_in: 1.day) do
            browser.get(URL)

            accept_cookie
            close_basket

            pending_efts = []
            loop do
              pending_efts += funds
              break unless next_page
            end
            pending_efts
          end
        end

        private

        def accept_cookie
          find_element(css: '.eu-cookie-compliance-banner .decline-button').click
        rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        end

        def close_basket
          find_element(css: '.close-widget').click
          find_element(css: '.close-popup').click
        rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError
        end

        def next_page
          find_element(css: '.pager__item--next a').click
          sleep 5
        rescue Selenium::WebDriver::Error::TimeoutError
          false
        end

        def funds
          find_elements(css: '.views-element-container table tbody tr').map do |tr|
            name = tr.find_element(css: '.views-field-name').text.strip
            isin = tr.find_element(css: '.views-field-field-b30-isin').text.strip
            symbol = tr.find_element(css: '.views-field-field-b30-symbol').text.strip

            PendingEtf.new(
              name: name,
              symbol: symbol,
              isin: isin
            )
          end
        end
      end
    end
  end
end