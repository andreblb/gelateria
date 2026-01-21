class PedidosController < ApplicationController
  before_action :set_pedido, only: %i[ show edit update destroy ]

  # GET /pedidos
  def index
    # Usamos o .includes(:customer) para carregar o nome do cliente mais rápido (otimização PostgreSQL)
    @pedidos = Pedido.all.includes(:customer)
  end

  # GET /pedidos/1
  def show
    # Aqui você pode ver os sabores incluídos no pedido
    @itens = @pedido.pedido_items.includes(:product)
  end

  # GET /pedidos/new
  def new
    @pedido = Pedido.new
    # Isso garante que o formulário saiba que pode receber itens
    @pedido.pedido_items.build
  end

  # GET /pedidos/1/edit
  def edit
  end

  # POST /pedidos
  def create
    @pedido = Pedido.new(pedido_params)

    respond_to do |format|
      if @pedido.save
        format.html { redirect_to @pedido, notice: "Pedido criado com sucesso!" }
        format.json { render :show, status: :created, location: @pedido }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pedidos/1
  def update
    respond_to do |format|
      if @pedido.update(pedido_params)
        format.html { redirect_to @pedido, notice: "Pedido atualizado com sucesso!", status: :see_other }
        format.json { render :show, status: :ok, location: @pedido }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pedidos/1
  def destroy
    @pedido.destroy!

    respond_to do |format|
      format.html { redirect_to pedidos_path, notice: "Pedido excluído.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks para compartilhar configuração comum entre as ações.
  def set_pedido
    # Ajustado para usar params[:id] que é o padrão mais estável
    @pedido = Pedido.find(params[:id])
  end

  # O AJUSTE MAIS IMPORTANTE: Adicionando os atributos aninhados (sabores)
  def pedido_params
    params.require(:pedido).permit(
      :customer_id,
      :total_price,
      :discount_percent,
      :status,
      :delivery_address,
      pedido_items_attributes: [ :id, :product_id, :quantity, :_destroy ]
    )
  end
end
