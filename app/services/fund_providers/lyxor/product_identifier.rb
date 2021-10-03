module FundProviders
  module Lyxor
    # Transform url into identifier
    # https://www.lyxoretf.co.uk/en/retail/products/equity-etf/lyxor-china-enterprise-hscei-ucits-etf-acc/lu1900068914/gbp > lyxoretf/equity-etf/lyxor-china-enterprise-hscei-ucits-etf-acc/lu1900068914/gbp
    class ProductIdentifier < Service
      NAMESPACE = 'lyxor'.freeze
      URL_REGEXP = /products\/(.+)/i.freeze

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