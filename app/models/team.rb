class Team < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  has_one :wallet, as: :walletable, dependent: :destroy
  has_many :stock_ownerships, as: :owner
  has_many :stocks, through: :stock_ownerships

  validates :name, presence: true
end
