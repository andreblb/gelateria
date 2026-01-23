class Pedido < ApplicationRecord
  belongs_to :customer
  has_many :pedido_items, dependent: :destroy
  has_many :products, through: :pedido_items
  
  # 1. Rejeita itens com quantidade 0 automaticamente
  # 2. allow_destroy permite limpar a lista se necessário
  accepts_nested_attributes_for :pedido_items, 
                                allow_destroy: true, 
                                reject_if: proc { |att| att['quantity'].to_i <= 0 }

  # Validação básica para garantir que não salve sem cliente
  validates :customer_id, presence: true

  # Centralizamos a lógica de cálculo aqui
  def calcular_total!
    subtotal = pedido_items.map { |item| (item.product&.price || 0) * (item.quantity || 0) }.sum
    desconto = subtotal * (discount_percent.to_f / 100.0)
    self.total_price = subtotal - desconto
  end
end