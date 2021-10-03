class Ticker < ApplicationRecord
  belongs_to :exchange
  belongs_to :instrument
  # habtm to broker

  enum kind: {
    bloomberg: 'bloomberg',
    ric: 'ric', #Reuters Code
    global: 'global',
    sedol: 'sedol'
  }

  validates :isin, :ticker, :currency, :kind, presence: true
end
