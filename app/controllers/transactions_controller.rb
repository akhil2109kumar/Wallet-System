class TransactionsController < ApplicationController
  def index
    transactions = Transaction.all
    render json: transactions
  end

  def show
    transaction = Transaction.find(params[:id])
    render json: transaction
  end

  def fetch_by_date_range
    start_date = params[:start_date]
    end_date = params[:end_date]
    if start_date.blank? || end_date.blank?
      render json: { error: "Both start_date and end_date are required" }, status: :unprocessable_entity
      return
    end

    transactions = Transaction.where(created_at: start_date..end_date)
    render json: transactions
  end

  def fetch_by_wallet
    wallet_id = params[:wallet_id]
    if wallet_id.blank?
      render json: { error: "wallet_id is required" }, status: :unprocessable_entity
      return
    end

    transactions = Transaction.where("source_wallet_id = ? OR target_wallet_id = ?", wallet_id, wallet_id)
    render json: transactions
  end

  def filter_by_user
    user_id = params[:user_id]
    user_name = params[:user_name]

    if user_id.blank? && user_name.blank?
      render json: { error: "Either user_id or user_name is required" }, status: :unprocessable_entity
      return
    end
    user =	if user_id.present?
             User.find_by(id: user_id)
            elsif user_name.present?
             User.find_by(name: user_name)
            end
    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end
    wallet = user.wallet
    transactions = Transaction.where("source_wallet_id = ? OR target_wallet_id = ?", wallet.id, wallet.id)

    render json: transactions
  end
end
