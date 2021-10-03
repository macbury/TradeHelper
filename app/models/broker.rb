class Broker < ApplicationRecord
  has_many :broker_instruments, dependent: :destroy
  has_many :instruments, through: :broker_instruments

  validates :name, :url, presence: true, uniqueness: true
end
