class CreatePedidoItems < ActiveRecord::Migration[8.1]
  def change
    create_table :pedido_items do |t|
      t.references :pedido, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
