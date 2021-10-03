module Brokers
  module Instruments
    module Match
      # Match PendingEtf by its symbol
      class BySymbol < TransactionService
        def initialize(broker:, pending_etfs:)
          @broker = broker
          @pending_etfs = pending_etfs
          @missing_etfs = []
        end

        def call
          broker.broker_instruments.destroy_all

          pending_etfs.each do |pending_etf|
            ticker = Ticker.find_by(ticker: pending_etf.symbol)
            unless ticker
              @missing_etfs << pending_etf
              next
            end

            broker.broker_instruments.create!(
              instrument: ticker.instrument,
              matched_by: :symbol,
              match: pending_etf.symbol
            )
          end

          @missing_etfs
        end

        private

        attr_reader :broker, :pending_etfs
      end
    end
  end
end
