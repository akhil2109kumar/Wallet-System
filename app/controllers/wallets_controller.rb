class WalletsController < ApplicationController
  before_action :set_walletable,  except: :transfer

  def show
    render json: { wallet: @wallet }, status: :ok
  end

  def credit
    amount = params[:amount].to_f
    Credit.create!(target_wallet: @wallet, amount: amount).apply!
    render json: { message: "Amount credited successfully", balance: @wallet.balance.to_f }
  end

  def debit
    amount = params[:amount].to_f
    Debit.create!(source_wallet: @wallet, amount: amount).apply!
    render json: { message: "Amount debited successfully", balance: @wallet.balance.to_f }
  end

  def transfer
    source_wallet = Wallet.find(params[:source_wallet_id])
    target_wallet = Wallet.find(params[:target_wallet_id])
    source_name = source_wallet.walletable.name
    target_name = target_wallet.walletable.name
    amount = params[:amount].to_f
    Transfer.create!(source_wallet: source_wallet, target_wallet: target_wallet, amount: amount).apply!
    render json: { message: "#{source_name} transfer #{amount} to #{target_name} successfully",
                            "#{source_name} wallet Balance": source_wallet.balance.to_f, "#{target_name} wallet Balance": target_wallet.balance.to_f }
  end

  def transfer_to_user
    unless @walletable.is_a?(Team)
      return render json: { error: "Transfer is only allowed from a team's wallet" }, status: :unprocessable_entity
    end

    user = User.find_by(id: params[:user_id])
    amount = params[:amount].to_f

    if invalid_user_or_amount?(user, amount)
      return render json: { error: invalid_user_or_amount_message(user, amount) }, status: :unprocessable_entity
    end

    unless @walletable.users.exists?(user.id)
      return render json: { error: "User is not a member of the team" }, status: :unprocessable_entity
    end

    process_transfer(@walletable.wallet, user.wallet, amount)
  end

  private

  def set_walletable
    begin
      klass = params[:walletable_type].constantize
      @walletable = klass.find(params[:id])
      @wallet = @walletable.wallet
    rescue NameError
      render json: { error: "Invalid walletable type" }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Walletable not found" }, status: :not_found
    end
  end

  def invalid_user_or_amount?(user, amount)
    user.nil? || amount <= 0
  end

  def invalid_user_or_amount_message(user, amount)
    if user.nil?
      "User not found"
    elsif amount <= 0
      "Transfer amount must be greater than zero"
    end
  end

  def process_transfer(team_wallet, user_wallet, amount)
    if team_wallet.balance < amount
      render json: { error: "Insufficient funds in the team's wallet" }, status: :unprocessable_entity
    else
      ActiveRecord::Base.transaction do
        team_wallet.update!(balance: team_wallet.balance - amount)
        user_wallet.update!(balance: user_wallet.balance + amount)
      end

      render json: {
        message: "#{team_wallet.walletable.name} transferred #{amount} to #{user_wallet.walletable.name} successfully",
        "#{team_wallet.walletable.name} Balance": team_wallet.balance,
        "#{user_wallet.walletable.name} Balance": user_wallet.balance
      }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
