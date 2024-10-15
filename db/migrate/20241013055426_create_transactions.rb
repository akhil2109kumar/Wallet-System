class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }, index: true, null: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, index: true, null: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :type, null: false

      t.timestamps
    end
  end
end
