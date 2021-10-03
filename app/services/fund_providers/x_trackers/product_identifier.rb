module FundProviders
  module XTrackers
    # Transform url into identifier
    # https://etf.dws.com/en-gb/LU0322252924-ftse-vietnam-swap-ucits-etf-1c/ > xtrackers/LU0322252924-ftse-vietnam-swap-ucits-etf-1c
    class ProductIdentifier < Service
      NAMESPACE = 'xtrackers'.freeze
      URL_REGEXP = /\/en-gb\/(.+)\//i.freeze

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