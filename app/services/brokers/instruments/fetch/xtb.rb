module Brokers
  module Instruments
    module Fetch
      # Use unoficial api for xtb.com to fetch etf names
      class Xtb < Service
        def call
          Rails.cache.fetch('brokers/xtb/pending_instruments', expires_in: 1.day) do
            etfs = []
            next_instruments do |instruments|
              etfs += instruments.map do |info|
                PendingEtf.new(
                  symbol: info['symbol'].split('.')[0],
                  name: info['display_name'],
                  isin: nil
                )
              end
            end
            etfs
          end
        end

        private

        def next_instruments
          page = 0
          loop do
            instruments = fetch_page(page)

            break if instruments.empty?

            yield instruments
            page += 1
          end
        end

        def page_url(page = 0)
          "https://www.xtb.com/api/pl/instruments/get?queryString=&instrumentTypeSlug=etfs&page=#{page}"
        end

        def fetch_page(page)
          response = JSON.parse(URI.open(page_url(page)).read)
          return [] if response['instrumentsCollectionLimited'].empty?

          response.dig('instrumentsCollectionLimited', 'etfs')&.values || []
        end
      end
    end
  end
end