class StocksController < ApplicationController
  before_action :set_stock, only: [ :show, :update, :destroy ]

  def show
    render json: @stock, status: :ok
  end

  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      Wallet.create(walletable: @stock)
      render json: @stock, status: :created
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  def update
    if @stock.update(stock_params)
      render json: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    render json: { error: "stock deleted successfully" }, status: :ok
  end

  def prices
    stocks = Stock.select(:id, :name, :price)
    render json: stocks, status: :ok
  end

  def find_stock
    stock = Stock.find_by("name = ? OR symbol = ?", params[:name], params[:symbol])

    if stock
      render json: stock, status: :ok
    else
      render json: { error: "Stock not found" }, status: :not_found
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Stock not found" }, status: :not_found
  end

  def stock_params
    params.require(:stock).permit(:name, :symbol, :price)
  end
end
