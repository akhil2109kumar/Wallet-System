require 'rails_helper'

RSpec.describe StockOwnershipsController, type: :controller do
  let!(:user) { User.create!(name: 'Test User', email: 'test@gmail.com', password: '1234455') }
  let!(:stock) { Stock.create!(name: 'Test Stock', symbol: 'TS', price: 100.0) }
  let!(:stock_ownership) { StockOwnership.create!(owner: user, stock: stock, quantity: 10) }

  describe 'POST #buy' do
    context 'with valid parameters' do
      let(:valid_params) { { user_id: user.id, id: stock.id, quantity: 5 } }

      it 'buys the stock and returns a success message' do
        expect(StockPurchaseService).to receive(:buy_stock).with(user, stock, 5, 500.0)

        post :buy, params: valid_params

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include(
          'message' => "#{user.name} purchased #{stock.name} successfully."
        )
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user_id: user.id, id: stock.id, quantity: -5 } }

      it 'returns an error message' do
        post :buy, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end

  describe 'POST #sell' do
    context 'with valid parameters' do
      let(:valid_params) { { user_id: user.id, id: stock_ownership.id, quantity: 5, sell_price: 120.0 } }

      it 'sells the stock and returns a success message' do
        expect(StockPurchaseService).to receive(:sell_stock).with(user, stock_ownership, 5, 120.0)

        post :sell, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          'message' => 'Stock sold successfully.'
        )
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user_id: user.id, id: stock_ownership.id, quantity: 15, sell_price: 120.0 } }

      it 'returns an error message when selling more than available quantity' do
        post :sell, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end
end
