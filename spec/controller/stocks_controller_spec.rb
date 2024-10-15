require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  let!(:stock) { create(:stock, name: "Test Stock", symbol: "TST", price: 100.0) }

  describe "GET #show" do
    it "returns the stock" do
      get :show, params: { id: stock.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['name']).to eq(stock.name)
    end

    it "returns a not found error if the stock does not exist" do
      get :show, params: { id: -1 }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq("Stock not found")
    end
  end
  describe "POST #create" do
    context "with invalid attributes" do
      let(:invalid_attributes) { { stock: { name: "", symbol: "", price: -50 } } }

      it "does not create a new stock" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Stock, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    let!(:stock) { Stock.create(name: "Test Stock", symbol: "TS", price: 100.0) }

    context "with valid attributes" do
      let(:valid_attributes) { { stock: { price: 120.0 } } }

      it "updates the stock" do
        put :update, params: { id: stock.id, stock: { price: 120.0 } }
        stock.reload
        expect(stock.price).to be_within(0.01).of(120.0)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { {} }

      it "does not update the stock" do
        put :update, params: { id: stock.id, stock: { name: "" } }
        stock.reload
        expect(stock.name).to eq("Test Stock") # Check that the name hasn't changed
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #prices" do
    it "returns all stocks' prices" do
      get :prices
      expect(response).to have_http_status(:ok)
      expect(json_response).to include(
        a_hash_including('id' => stock.id, 'name' => stock.name, 'price' => stock.price.to_s) # Convert price to string for comparison
      )
    end
  end


  describe "GET #find_stock" do
    context "when stock is found by name" do
      it "returns the stock" do
        get :find_stock, params: { name: stock.name }
        expect(response).to have_http_status(:ok)
        expect(json_response['name']).to eq(stock.name)
      end
    end

    context "when stock is found by symbol" do
      it "returns the stock" do
        get :find_stock, params: { symbol: stock.symbol }
        expect(response).to have_http_status(:ok)
        expect(json_response['symbol']).to eq(stock.symbol)
      end
    end

    context "when stock is not found" do
      it "returns a not found error" do
        get :find_stock, params: { name: "Nonexistent" }
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq("Stock not found")
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
