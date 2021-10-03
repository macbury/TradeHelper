module FundProviders
  module Lyxor
    class FetchAllForCountry < BrowserService
      use AcceptTerms, as: :accept_terms

      def initialize(url:, **kwargs)
        super(**kwargs)
        @url = url
      end

      def call
        browser.get(url)

        accept_terms(browser)
        select_max_page_size

        @all = []

        each_asset do |asset|
          each_page do
            @all += funds.map { |tr| build_etf_option(tr, asset) }
          end
        end
        @all
      end

      private

      attr_reader :url

      def funds
        find_elements(css: '.ui-datatable-tablewrapper table tbody tr')
      end

      def wait_for_funds
        funds
      end

      def select_max_page_size
        find_elements(css: '.finder-data-table select option').last.click
      end

      def each_asset
        asset_buttons.size.times do |index|
          next if asset_button(index).text.empty?

          click_on_asset_filter(index)
          sleep 10
          yield asset_button(index).find_element(css: '.filterButtonText').text.strip
        end
      end

      def click_on_asset_filter(index, retry_left = 3)
        scroll_top
        asset_button(index).click unless index.zero? # First tab is already clicked
      rescue Selenium::WebDriver::Error::ElementClickInterceptedError
        click_on_asset_filter(index, retry_left - 1) if retry_left.positive?
      end

      def each_page
        yield
        while go_to_next_page
          sleep 10
          yield
        end
      end

      def go_to_next_page
        scroll_bottom
        find_element(id: 'tabViewForm:tabView:shareDatatable_paginator_bottom').find_element(css: '.ui-paginator-next', timeout: 10).click
        true
      rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementNotInteractableError, Selenium::WebDriver::Error::ElementClickInterceptedError
        false
      end

      def asset_buttons
        find_element(id: 'tabViewForm:tabView:assetClassFilterPanel').find_elements(css: '.customAssetclassBTN')
      end

      def asset_button(index)
        asset_buttons[index]
      end

      def build_etf_option(tr, asset)
        cols = tr.find_elements(tag_name: 'td')

        a = cols[1].find_element(tag_name: 'a')
        symbol = cols[0].text
        isin = cols[3].text

        PendingInstrument.new(
          name: a.text,
          url: a.attribute(:href),
          asset: asset,
          symbol: symbol,
          isin: isin
        )
      rescue Selenium::WebDriver::Error::TimeoutError
        nil
      end
    end
  end
end