# spec/controllers/wallets_controller_spec.rb

require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:wallet_for_user) { create(:wallet, :for_user, walletable: user) }

  let!(:team) { create(:team) }
  let!(:wallet_for_team) { create(:wallet, :for_team, walletable: team) }

  describe 'GET #show' do
    before { get :show, params: { id: wallet_for_user.walletable.id, walletable_type: 'User' } }

    it 'returns the wallet' do
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include('wallet' => wallet_for_user.as_json)
    end
  end

  describe 'POST #credit' do
    let(:amount) { 100.0 }

    before do
      post :credit, params: { id: wallet_for_user.walletable.id, walletable_type: 'User', amount: amount }
    end

    it 'credits the amount to the wallet' do
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include('message' => 'Amount credited successfully', 'balance' => (wallet_for_user.balance + amount))
    end
  end

  describe 'POST #debit' do
    let(:amount) { 50.0 }

    before do
      post :debit, params: { id: wallet_for_user.walletable.id, walletable_type: 'User', amount: amount }
    end

    it 'debits the amount from the wallet' do
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include('message' => 'Amount debited successfully', 'balance' => (wallet_for_user.balance - amount))
    end
  end
end
