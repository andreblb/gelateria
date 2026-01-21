json.extract! pedido, :id, :customer_id, :total_price, :discount_percent, :status, :delivery_address, :created_at, :updated_at
json.url pedido_url(pedido, format: :json)
