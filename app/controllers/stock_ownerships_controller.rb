class StockOwnershipsController < ApplicationController
  def buy
    owner = User.find(params[:user_id]) # or Team.find(params[:team_id]) based on input
    stock = Stock.find(params[:id])
    quantity = params[:quantity].to_i
    total_price = quantity * stock.price

    StockPurchaseService.buy_stock(owner, stock, quantity, total_price)
    render json: { message: "#{owner.name} purchased #{stock.name} successfully." }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def sell
    owner = User.find(params[:user_id]) # or Team.find(params[:team_id]) based on input
    stock_ownership = StockOwnership.find(params[:id])
    quantity = params[:quantity].to_i
    sell_price = params[:sell_price].to_f

    StockPurchaseService.sell_stock(owner, stock_ownership, quantity, sell_price)
    render json: { message: "Stock sold successfully." }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
