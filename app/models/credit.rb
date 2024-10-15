
class Credit < Transaction
  validate :target_wallet_presence
  # Credit transactions add money to the target wallet.
  def apply!
    raise "Target wallet is required for credit transactions" if target_wallet.nil?

    ActiveRecord::Base.transaction do
      target_wallet.increment!(:balance, amount)
      save!
    end
  end

  private

  def target_wallet_presence
    errors.add(:target_wallet, "must be present for credits") unless target_wallet.present?
  end
end
