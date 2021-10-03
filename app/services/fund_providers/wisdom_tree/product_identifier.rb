module FundProviders
  module WisdomTree
    # Transform url into identifier
    # https://www.wisdomtree.eu/en-gb/products/short-leveraged-etps/currencies/wisdomtree-short-chf-long-eur-3x-daily > wisdom_tree/short-leveraged-etps/currencies/wisdomtree-short-chf-long-eur-3x-daily
    class ProductIdentifier < Service
      NAMESPACE = 'wisdom_tree'.freeze
      URL_REGEXP = /(commodities|products|equities|fixed-income|etfs\/thematic|etfs\/small-cap-dividend|etfs\/export-tilted)\/(.+)/i.freeze

      attr_reader :url

      def initialize(url)
        @url = url
      end

      def call
        match = url.split('/')[-1]
        raise ServiceFailure, "Could not extract identifier from: #{url}" unless match

        [NAMESPACE, match].join('/')
      end
    end
  end
end