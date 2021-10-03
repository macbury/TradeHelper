class BrokerInstrument < ApplicationRecord
  belongs_to :broker
  belongs_to :instrument, optional: true #TODO: hmm this should probabbly go through ticker

  enum matched_by: {
    isin: :isin,
    symbol: :symbol
  }

  validates :match, presence: true
end
