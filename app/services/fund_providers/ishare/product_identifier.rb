module FundProviders
  module Ishare
    # Transform url into identifier
    # https://www.ishares.com/uk/individual/en/products/251464/ishares-dax-ucits-etf-de-fund > ishares/251464
    class ProductIdentifier < Service
      NAMESPACE = 'ishare'.freeze
      URL_REGEXP = /(products|produkte)\/([0-9]+)/i.freeze

      attr_reader :url

      def initialize(url)
        @url = url
      end

      def call
        match = URL_REGEXP.match(url)
        raise ServiceFailure, "Could not extract identifier from: #{url}" unless match

        [NAMESPACE, match[2].to_i].join('/')
      end
    end
  end
end