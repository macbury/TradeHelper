class FundProvider < ApplicationRecord
  has_many :instruments, dependent: :destroy

  validates :name, :url, presence: true, uniqueness: true
end
