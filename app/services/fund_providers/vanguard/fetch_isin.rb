module FundProviders
  module Vanguard
    class FetchIsin < BrowserService
      attr_reader :url

      ISIN_REGEXP = /ISIN: (IE[0-9A-Z]{10})/i.freeze

      def call
        match = lines.match(ISIN_REGEXP)
        match[1]
      end

      private

      def kid_url
        @kid_url ||= find_element(link_text: 'Key Investor Information Document').attribute(:href)
      end

      def kid_pdf_file
        @kid_pdf_file ||= Down.download(kid_url)
      end

      def pdf
        @pdf ||= PDF::Reader.new(kid_pdf_file)
      end

      def lines
        @lines ||= pdf.pages.flat_map { |page| page.text.split("\n") }.map(&:strip).reject(&:empty?).join("\n")
      end
    end
  end
end