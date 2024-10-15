Rails.application.routes.draw do
  post "/sign_in", to: "sessions#create"
  delete "/sign_out", to: "sessions#destroy"

  # User routes
  resources :users do
    member do
      get :wallet, to: "wallets#show", defaults: { walletable_type: "User" }
      post :credit, to: "wallets#credit", defaults: { walletable_type: "User" }
      post :debit, to: "wallets#debit", defaults: { walletable_type: "User" }
    end
  end

  # Team routes
  resources :teams do
    member do
      get :wallet, to: "wallets#show", defaults: { walletable_type: "Team" }
      post :credit, to: "wallets#credit", defaults: { walletable_type: "Team" }
      post :debit, to: "wallets#debit", defaults: { walletable_type: "Team" }
      post :transfer_to_user, to: "wallets#transfer_to_user", defaults: { walletable_type: "Team" }
      get :team_users
      post :add_users
      delete :remove_user
    end
    collection do
      get :filter, to: "teams#filter"
    end
  end

  # Stock routes
  resources :stocks, only: [ :create, :show, :update, :destroy ] do
    member do
      get :wallet, to: "wallets#show", defaults: { walletable_type: "Stock" }
    end
    collection do
      get :prices, to: "stocks#prices" # for the price_all endpoint
      get "stocks_name", to: "stocks#find_stock"
  end
  end

  # Wallet transfer between entities
  post "/wallets/transfer", to: "wallets#transfer"

  # Transactions routes
  resources :transactions, only: [ :index, :show ] do
    collection do
      get "date_range", to: "transactions#fetch_by_date_range"
      get "wallet", to: "transactions#fetch_by_wallet"
      get :filter_by_user
    end
  end

  # StockOwnership routes for managing stock purchases and sales
  resources :stock_ownerships, only: [ :create, :show, :update, :destroy ] do
    member do
      post :buy, to: "stock_ownerships#buy"
      post :sell, to: "stock_ownerships#sell"
    end
  end
end
