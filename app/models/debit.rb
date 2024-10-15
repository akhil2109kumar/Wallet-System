class Debit < Transaction
  validate :source_wallet_presence
  # Debit transactions withdraw money from the source wallet.
  def apply!
    raise "Source wallet is required for debit transactions" if source_wallet.nil?
    raise "Insufficient funds" if source_wallet.balance < amount

    ActiveRecord::Base.transaction do
      source_wallet.decrement!(:balance, amount)
      save!
    end
  end

  private

  def source_wallet_presence
    errors.add(:source_wallet, "must be present for debits") unless source_wallet.present?
  end
end
