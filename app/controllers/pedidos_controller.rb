class PedidosController < ApplicationController
  # Corrigindo o erro do index: agora buscamos todos os pedidos
  def index
    @pedidos = Pedido.all.includes(:customer)
  end

  def new
    if params[:pedido]
      @pedido = Pedido.new(pedido_params)
      
      # Captura os IDs dos sabores marcados
      ids = params[:pedido][:pedido_items_attributes]&.map { |i| i[:product_id] }&.reject(&:blank?)
      
      if ids.present?
        # Ruby faz o cálculo
        subtotal = Product.where(id: ids).sum(:price)
        desconto = subtotal * (@pedido.discount_percent.to_f / 100.0)
        @pedido.total_price = subtotal - desconto
        
        # Mantém os itens marcados na tela após o recarregamento
        @pedido.product_ids = ids
      end
    else
      @pedido = Pedido.new
    end
  end

  def create
    @pedido = Pedido.new(pedido_params)
    # Lógica de segurança para garantir o preço antes de salvar
    ids = params[:pedido][:pedido_items_attributes]&.map { |i| i[:product_id] }&.reject(&:blank?)
    subtotal = Product.where(id: ids).sum(:price)
    @pedido.total_price = subtotal - (subtotal * (@pedido.discount_percent.to_f / 100.0))

    if @pedido.save
      redirect_to @pedido, notice: "Pedido realizado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pedido = Pedido.find(params[:id])
  end

  private

  def pedido_params
    params.require(:pedido).permit(:customer_id, :delivery_address, :discount_percent, :total_price,
                                   pedido_items_attributes: [:product_id])
  end
end