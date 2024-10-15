class CreateStockOwnerships < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_ownerships do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :owner, polymorphic: true, null: false
      t.integer :quantity
      t.decimal :purchase_price

      t.timestamps
    end
  end
end
