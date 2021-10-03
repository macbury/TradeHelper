class Instrument < ApplicationRecord
  belongs_to :fund_provider

  has_many :broker_instruments, dependent: :destroy
  has_many :brokers, through: :broker_instruments
  has_many :tickers, dependent: :destroy
  has_many :exchanges, -> { distinct }, through: :tickers

  enum asset: {
    equity: 'equity',
    bonds: 'bonds',
    multi_asset: 'multi_asset',
    real_estate: 'real_estate',
    commodity: 'commodity'
  }

  enum profit: {
    accumulated: 'accumulated',
    distributed: 'distributed'
  }

  enum replication: {
    physical: 'physical',
    synthetic: 'synthetic'
  }

  validates :product_identifier, presence: true, uniqueness: true
  validates :name, :details_url, :currency, :residence, presence: true
  validates :asset, :profit, :replication, presence: true
end
