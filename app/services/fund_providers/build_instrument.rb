module FundProviders
  # Build instrument from fetched details from instrument webpage
  class BuildInstrument < Service
    use MatchExchange, as: :match_exchange

    def initialize(pending_instrument:, fund_provider:)
      @pending_instrument = pending_instrument
      @fund_provider = fund_provider
    end

    def call
      raise ServiceFailure, "Invalid kind for instrument details: #{instrument_details.class.name}" unless instrument_details.is_a?(InstrumentDetails)

      Instrument.transaction do
        instrument = fund_provider.instruments.find_or_initialize_by(product_identifier: instrument_details.product_identifier)
        instrument.assign_attributes(instrument_attributes)
        instrument.save!

        instrument.tickers.destroy_all

        instrument_details.tickers.each do |exchange_ticker|
          exchange = match_exchange(exchange_ticker.exchange_name)

          instrument.tickers.create!(
            exchange: exchange,
            kind: exchange_ticker.kind,
            isin: exchange_ticker.isin,
            ticker: exchange_ticker.ticker,
            currency: exchange_ticker.currency
          )
        end
      end
    end

    private

    attr_reader :pending_instrument, :fund_provider

    def fetch_details
      case fund_provider.id
      when 'ishare' then Ishare::FetchDetails
      when 'xtrackers' then XTrackers::FetchDetails
      when 'ssga' then Spdr::FetchDetails
      when 'lyxor' then Lyxor::FetchDetails
      when 'vanguard' then Vanguard::FetchDetails
      when 'vaneck' then Vaneck::FetchDetails
      when 'wisdom_tree' then WisdomTree::FetchDetails
      else
        raise ServiceFailure, "Create missing class for fetching details of instrument for #{fund_provider.id}"
      end
    end

    def instrument_details
      @instrument_details ||= fetch_details.call(pending_instrument: pending_instrument)
    end

    def instrument_attributes
      instrument_details.to_h.except(:tickers)
    end
  end
end