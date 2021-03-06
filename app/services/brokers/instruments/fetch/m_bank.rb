module Brokers
  module Instruments
    module Fetch
      # https://www.mdm.pl/ds-server/41304?ticketSource=ui-pub sprawdz
      # https://www.mdm.pl/ui-pub/site/oferta_indywidualna/rynki_zagraniczne/lista_dostepnych_akcji_etf_i_adrgdr
      # Fetch current ETFs provided by mbank and return them as PendingEtf struct
      class MBank < Service
        URL = 'https://www.mbank.pl/pdf/ind/inwestycje/lista-funduszy-etf.pdf'.freeze #TODO: Move this to initializer and fetch on demand
        EXCHANGE_NAME = /(.+)\((.+)\)/i.freeze

        def call
          Rails.cache.fetch('brokers/mbank/pending_instruments', expires_in: 1.day) do
            lines.map do |line|
              row = split(line)
              next unless row.size == 8

              PendingEtf.new(
                name: row[2]&.strip,
                symbol: row[4]&.strip,
                isin: row[6]&.strip
              )
            end.compact
          end
        end

        private

        def content
          @content ||= Down.download(URL)
        end

        def pdf
          @pdf ||= PDF::Reader.new(content)
        end

        def lines
          @lines ||= pdf.pages.flat_map { |page| page.text.split("\n") }.map(&:strip).reject(&:empty?)
        end

        def split(line)
          line.split(/ {3}/i).map(&:strip).reject(&:empty?)
        end

        def split_exchange_from_currency(col)
          match = col.match(EXCHANGE_NAME)
          match[1..2]
        end
      end
    end
  end
end