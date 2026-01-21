class Pedido < ApplicationRecord
  belongs_to :customer
  has_many :pedido_items, dependent: :destroy
  has_many :products, through: :pedido_items

  # Essencial para o controller aceitar os sabores
  accepts_nested_attributes_for :pedido_items, allow_destroy: true
end
