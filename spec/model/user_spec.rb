require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:memberships) }
    it { should have_many(:teams).through(:memberships) }
    it { should have_one(:wallet).dependent(:destroy) }
    it { should have_many(:stock_ownerships) }
    it { should have_many(:stocks).through(:stock_ownerships) }
  end

  describe 'validations' do
    it { should have_secure_password }
    it { should have_secure_token(:auth_token) }
  end
end
