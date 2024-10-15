# spec/models/stock_ownership_spec.rb
require 'rails_helper'

RSpec.describe StockOwnership, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
    it { is_expected.to belong_to(:owner) }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  describe 'polymorphic association' do
    let(:user) { create(:user) }
    let(:stock) { create(:stock) }

    it 'can be associated with a user' do
      stock_ownership = StockOwnership.new(stock: stock, owner: user, quantity: 10)
      expect(stock_ownership.owner).to eq(user)
    end

    it 'can be associated with a team' do
      team = create(:team)
      stock_ownership = StockOwnership.new(stock: stock, owner: team, quantity: 5)
      expect(stock_ownership.owner).to eq(team)
    end
  end
end
