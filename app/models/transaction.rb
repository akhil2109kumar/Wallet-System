class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :type, presence: true

  # Method to apply the transaction's effect to the wallets
  def apply!
    raise NotImplementedError, "Subclasses must define `apply!`"
  end

  # Scopes for different transaction types
  scope :credits, -> { where(type: "Credit") }
  scope :debits, -> { where(type: "Debit") }
  scope :transfers, -> { where(type: "Transfer") }
end
