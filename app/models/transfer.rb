class Transfer < Transaction
  # Transfer transactions move money from the source wallet to the target wallet.
  def apply!
    raise "Source wallet is required for transfer transactions" if source_wallet.nil?
    raise "Target wallet is required for transfer transactions" if target_wallet.nil?
    raise "Insufficient funds" if source_wallet.balance < amount

    ActiveRecord::Base.transaction do
      source_wallet.decrement!(:balance, amount)
      target_wallet.increment!(:balance, amount)
      save!
    end
  end
end
