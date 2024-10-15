class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_many :memberships
  has_many :teams, through: :memberships
  has_one :wallet, as: :walletable, dependent: :destroy
  has_many :stock_ownerships, as: :owner
  has_many :stocks, through: :stock_ownerships

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
