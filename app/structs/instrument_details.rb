# This struct should be used as base data payload returned by services that scrape Instrument details
class InstrumentDetails < Dry::Struct
  attribute :name, Types::String
  attribute :details_url, Types::String
  attribute :product_identifier, Types::String
  attribute :description, Types::String
  attribute :asset, Types::Symbol
  attribute :profit, Types::Symbol
  attribute :replication, Types::Symbol
  attribute :provision, Types::Float
  attribute :currency, Types::String
  attribute :residence, Types::String

  attribute :tickers, Types::Array.of(ExchangeTicker)
end