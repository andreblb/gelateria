class Product < ApplicationRecord
  has_many :pedido_items
  has_many :pedidos, through: :pedido_items
end