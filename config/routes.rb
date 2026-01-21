Rails.application.routes.draw do
  # Define a página inicial do sistema
  root "home#index" 

  resources :pedidos
  resources :products
  resources :customers
end