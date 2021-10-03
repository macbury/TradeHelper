class Exchange < ApplicationRecord
  has_many :tickers, dependent: :destroy
  has_many :instruments, through: :tickers

  validates :name, presence: true, uniqueness: true
end
