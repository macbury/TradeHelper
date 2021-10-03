class ExchangeTicker < Dry::Struct
  attribute :exchange_name, Types::String
  attribute :ticker, Types::String
  attribute :kind, Types::Symbol
  attribute :isin, Types::String
  attribute :currency, Types::String
end