module FundProviders
  module Vaneck
    # Transform url into identifier
    # "https://www.vaneck.com/ucits/etf/equity/espo/overview > vaneck/espo
    class ProductIdentifier < Service
      NAMESPACE = 'vaneck'.freeze
      URL_REGEXP = /(equity|income|balanced)\/(.+)\/overview/i.freeze

      attr_reader :url

      def initialize(url)
        @url = url
      end

      def call
        match = URL_REGEXP.match(url)
        raise ServiceFailure, "Could not extract identifier from: #{url}" unless match

        [NAMESPACE, match[2]].join('/')
      end
    end
  end
end