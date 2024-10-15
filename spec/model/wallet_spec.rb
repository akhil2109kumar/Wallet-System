require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'associations' do
    it { should belong_to(:walletable) }
  end

  describe 'polymorphic association' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    let(:user_wallet) { create(:wallet, walletable: user) }
    let(:team_wallet) { create(:wallet, walletable: team) }

    it 'can be associated with a user' do
      expect(user_wallet.walletable).to eq(user)
    end

    it 'can be associated with a team' do
      expect(team_wallet.walletable).to eq(team)
    end

    it 'returns the correct walletable type' do
      expect(user_wallet.walletable_type).to eq('User')
      expect(team_wallet.walletable_type).to eq('Team')
    end
  end
end
