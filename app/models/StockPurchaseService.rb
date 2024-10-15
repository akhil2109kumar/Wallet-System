class StockPurchaseService
  def self.buy_stock(owner, stock, quantity, total_price)
    ActiveRecord::Base.transaction do
      raise "Insufficient balance in #{owner.class.name.downcase}'s wallet." if owner.wallet.balance < total_price

      stock_ownership = StockOwnership.find_or_initialize_by(
        stock: stock,
        owner: owner
      )
      stock_ownership.quantity ||= 0
      stock_ownership.quantity += quantity
      stock_ownership.purchase_price = total_price
      stock_ownership.save!
      stock.wallet.update(balance: total_price)
      Debit.create!(source_wallet: owner.wallet, amount: total_price).apply!

      stock_ownership
    end
  end

  def self.sell_stock(owner, stock_ownership, quantity, sell_price)
    ActiveRecord::Base.transaction do
      if stock_ownership.quantity < quantity
        raise "Not enough shares to sell."
      end

      total_sale_amount = quantity * sell_price
      stock_ownership.update!(quantity: stock_ownership.quantity - quantity)
      Credit.create!(target_wallet: owner.wallet, amount: total_sale_amount).apply!
    end
  end
end
