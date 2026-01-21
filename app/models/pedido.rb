class Pedido < ApplicationRecord
  belongs_to :customer
  has_many :pedido_items, dependent: :destroy
  has_many :products, through: :pedido_items
  accepts_nested_attributes_for :pedido_items, allow_destroy: true

  def calcular_total_pelo_ruby
    # Soma o preço dos produtos associados no banco de dados
    subtotal = products.sum(:price)
    desconto = subtotal * (discount_percent.to_f / 100.0)
    self.total_price = subtotal - desconto
  end
end