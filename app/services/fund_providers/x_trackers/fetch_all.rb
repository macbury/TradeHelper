module FundProviders
  module XTrackers
    # Fetch all etfs for XTrackers
    class FetchAll < BrowserService
      URL = 'https://etf.dws.com/en-gb/fund-finder/?PageSize=100'.freeze
      use AcceptTerms, as: :accept_terms

      def call
        browser.get(URL)

        accept_terms(browser)
        wait_for_table

        sleep 1 until current_page == 1
        pending_etfs = []

        while current_page <= page_count
          each_instrument do |pedning_etf|
            pending_etfs << pedning_etf
          end

          break if current_page == page_count

          next_page
        end

        pending_etfs
      end

      private

      def wait_for_table
        find_element(css: '.table-search-product-finder', timeout: 60)
      end

      def each_instrument
        browser.find_elements(css: '.table-search-product-finder tbody tr').each do |row|
          columns = row.find_elements(css: 'td')
          a = columns[1].find_element(css: 'a')

          yield PendingInstrument.new(
            name: a.text,
            url: a.attribute(:href)
          )
        end
      end

      def next_page
        next_page = current_page + 1
        find_element(css: 'li.next .icons-arrow-right-dark').click

        sleep 1 until current_page == next_page
      end

      def page_count
        browser.find_elements(css: '.paginator li').map { |n| n.text.to_i }.max
      end

      def current_page
        browser.find_element(css: '.paginator li.active').text.to_i || 0
      end
    end
  end
end