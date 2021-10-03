module Broker
  # https://www.mdm.pl/ds-server/41304?ticketSource=ui-pub sprawdz
  #https://www.mdm.pl/ui-pub/site/oferta_indywidualna/rynki_zagraniczne/lista_dostepnych_akcji_etf_i_adrgdr
  # Fetch current ETFs provided by mbank and return them as PendingEtf struct
  class Bm_Mbank < Service
    URL = 'https://www.mdm.pl/ds-server/41304?ticketSource=ui-pub'.freeze 

    def call
      
    end

    private

    def content
      @content ||= URI.open(URL)
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
  end
end