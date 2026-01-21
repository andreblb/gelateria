class Customer < ApplicationRecord
  # Relacionamento: um cliente tem muitos pedidos
  # O 'dependent: :destroy' apaga os pedidos se o cliente for deletado
  has_many :pedidos, dependent: :destroy

  # Validações básicas para evitar cadastros vazios ou errados
  validates :name, :address, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  # Método para facilitar a exibição em selects (ex: Nome - Telefone)
  def display_name
    "#{name} - #{phone}"
  end
end