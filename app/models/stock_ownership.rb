class StockOwnership < ApplicationRecord
  belongs_to :stock
  belongs_to :owner, polymorphic: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
