# spec/models/team_spec.rb
require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:users).through(:memberships) }
    it { is_expected.to have_one(:wallet).dependent(:destroy) }
    it { is_expected.to have_many(:stock_ownerships) }
    it { is_expected.to have_many(:stocks).through(:stock_ownerships) }
  end
end
