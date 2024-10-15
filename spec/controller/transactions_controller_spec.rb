require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user) { User.create!(name: 'Test User', email: 'test@gmail.com', password: '12345') }
  let!(:team) { Team.create!(name: 'Development Team') }
  let!(:source_wallet) { Wallet.create!(balance: 100.0, walletable: user) }
  let!(:target_wallet) { Wallet.create!(balance: 50.0, walletable: team) }
  let!(:transaction1) { Transaction.create!(source_wallet: source_wallet, target_wallet: target_wallet, amount: 20.0, type: 'Credit') }
  let!(:transaction2) { Transaction.create!(source_wallet: source_wallet, target_wallet: target_wallet, amount: 30.0, type: 'Debit') }

  describe 'GET #index' do
    it 'returns all transactions' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET #show' do
    it 'returns a specific transaction' do
      get :show, params: { id: transaction1.id }
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq(transaction1.id)
      expect(parsed_body['amount'].to_f).to eq(transaction1.amount.to_f)
    end
  end

  describe "GET #fetch_by_date_range" do
    context 'with valid date range' do
      it 'returns transactions within the date range' do
        get :fetch_by_date_range, params: { start_date: 1.day.ago, end_date: 1.day.from_now }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'with missing start_date or end_date' do
      it 'returns an error when start_date is missing' do
        get :fetch_by_date_range, params: { end_date: 1.day.from_now }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Both start_date and end_date are required')
      end

      it 'returns an error when end_date is missing' do
        get :fetch_by_date_range, params: { start_date: 1.day.ago }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Both start_date and end_date are required')
      end
    end
  end

  describe 'GET #fetch_by_wallet' do
    context 'with valid wallet_id' do
      it 'returns transactions for the given wallet_id' do
        get :fetch_by_wallet, params: { wallet_id: source_wallet.id }
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body.size).to eq(2)
      end
    end

    context 'when wallet_id is missing' do
      it 'returns an error' do
        get :fetch_by_wallet
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('wallet_id is required')
      end
    end
  end

  describe 'GET #filter_by_user' do
    context 'with valid user_id' do
      it 'returns transactions for the given user_id' do
        get :filter_by_user, params: { user_id: user.id }
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body.size).to eq(2)
      end
    end

    context 'with valid user_name' do
      it 'returns transactions for the given user_name' do
        get :filter_by_user, params: { user_name: user.name }
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body.size).to eq(2)
      end
    end

    context 'when user is not found' do
      it 'returns an error when user_id does not exist' do
        get :filter_by_user, params: { user_id: 9999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
      end

      it 'returns an error when user_name does not exist' do
        get :filter_by_user, params: { user_name: 'Nonexistent User' }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
      end
    end
  end
end
