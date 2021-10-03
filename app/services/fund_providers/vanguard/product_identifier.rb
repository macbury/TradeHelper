module FundProviders
  module Vanguard
    # Transform url into identifier
    # https://www.vanguardinvestor.co.uk/investments/vanguard-ftse-developed-europe-ex-uk-ucits-etf-eur-distributing?intcmpgn=equityeurope_ftsedevelopedeuropeexukucitsetf_fund_link > vanguard/vanguard-ftse-developed-europe-ex-uk-ucits-etf-eur-distributing
    class ProductIdentifier < Service
      NAMESPACE = 'vanguard'.freeze
      URL_REGEXP = /investments\/(.+)\?/i.freeze

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