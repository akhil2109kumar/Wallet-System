class Stock < ApplicationRecord
  has_one :wallet, as: :walletable, dependent: :destroy
  has_many :stock_ownerships
  has_many :owners, through: :stock_ownerships, source: :owner, source_type: "User"
  has_many :teams, through: :stock_ownerships, source: :owner, source_type: "Team"

  validates :name, presence: true
  validates :symbol, presence: true
  validates :price, numericality: { greater_than: 0 }
end
