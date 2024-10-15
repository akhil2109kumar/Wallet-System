class TransactionsController < ApplicationController
  def index
    transactions = Transaction.all
    render json: transactions, status: :ok
  end

  def show
    transaction = Transaction.find(params[:id])
    render json: transaction, status: :ok
  end

  def fetch_by_date_range
    start_date = params[:start_date]
    end_date = params[:end_date]
    if start_date.blank? || end_date.blank?
      render json: { error: "Both start_date and end_date are required" }, status: :unprocessable_entity
    else
      transactions = Transaction.where(created_at: start_date..end_date)
      render json: transactions
    end
  end

  def fetch_by_wallet
    wallet_id = params[:wallet_id]
    if wallet_id.blank?
      render json: { error: "wallet_id is required" }, status: :unprocessable_entity
    else
      transactions = Transaction.where("source_wallet_id = ? OR target_wallet_id = ?", wallet_id, wallet_id)
      render json: transactions, status: :ok
    end
  end

  def filter_by_user
    user = find_user(params[:user_id], params[:user_name])
  
    if user.nil?
      render json: { error: "User not found" }, status: :not_found
    elsif user.wallet.nil?
      render json: { error: "Wallet not found for user" }, status: :not_found
    else
      transactions = Transaction.where("source_wallet_id = ? OR target_wallet_id = ?", user.wallet.id, user.wallet.id)
      render json: transactions, status: :ok
    end
  end

  private

  def find_user(user_id, user_name)
    return User.find_by(id: user_id) if user_id.present?

    User.find_by(name: user_name) if user_name.present?
  end
end
