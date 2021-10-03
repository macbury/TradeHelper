module FundProviders
  # Base class for all services that generate on output struc InstrumentDetails
  class BasicFetchDetails < BrowserService
    attr_reader :pending_instrument

    def initialize(pending_instrument:, **args)
      super(**args)
      @pending_instrument = pending_instrument
    end

    private

    # Visit page from pending instrument
    def visit_page
      browser.get('about:blank')
      browser.get(pending_instrument.url)

      find_elements(css: 'body div', timeout: 30.seconds)
    end
  end
end