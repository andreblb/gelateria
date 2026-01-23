class PedidosController < ApplicationController
  def index
    @pedidos = Pedido.all.includes(:customer)
  end

  def new
    @pedido = params[:pedido] ? Pedido.new(pedido_params) : Pedido.new
    @pedido.calcular_total! if params[:pedido]
  end

  def create
    @pedido = Pedido.new(pedido_params)
    @pedido.calcular_total! # Calcula antes de salvar

    if @pedido.save
      redirect_to @pedido, notice: "Pedido realizado com sucesso!"
    else
      # Se der erro, mostramos no log do terminal para você ver
      puts "ERROS: #{@pedido.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pedido = Pedido.find(params[:id])
  end

  private

  def pedido_params
    params.require(:pedido).permit(
      :customer_id, :delivery_address, :discount_percent, :total_price,
      pedido_items_attributes: [:product_id, :quantity, :_destroy]
    )
  end
end