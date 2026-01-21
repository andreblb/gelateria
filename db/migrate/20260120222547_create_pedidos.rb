class CreatePedidos < ActiveRecord::Migration[8.1]
  def change
    create_table :pedidos do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_price
      t.decimal :discount_percent
      t.string :status
      t.string :delivery_address

      t.timestamps
    end
  end
end
