module FundProviders
  module Spdr
    # Transform url into identifier
    # https://www.ssga.com/uk/en_gb/institutional/etfs/funds/spdr-bloomberg-barclays-7-10-year-us-treasury-bond-ucits-etf-dist-spp7-gy > spdr/spdr-bloomberg-barclays-7-10-year-us-treasury-bond-ucits-etf-dist-spp7-gy
    class ProductIdentifier < Service
      NAMESPACE = 'spdr'.freeze
      URL_REGEXP = /etfs\/funds\/(.+)/i.freeze

      attr_reader :url

      def initialize(url)
        @url = url
      end

      def call
        match = URL_REGEXP.match(url)
        raise ServiceFailure, "Could not extract identifier from: #{url}" unless match

        [NAMESPACE, match[1]].join('/')
      end
    end
  end
end