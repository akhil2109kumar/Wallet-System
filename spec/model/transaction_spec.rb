# spec/models/transaction_spec.rb
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:source_wallet).class_name('Wallet').optional }
    it { is_expected.to belong_to(:target_wallet).class_name('Wallet').optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:type) }
  end

  describe 'scopes' do
    let!(:credit_transaction) { create(:transaction, type: 'Credit', amount: 100) }
    let!(:debit_transaction) { create(:transaction, type: 'Debit', amount: 50) }
    let!(:transfer_transaction) { create(:transaction, type: 'Transfer', amount: 30) }

    describe '.credits' do
      it 'returns only credit transactions' do
        expect(Transaction.credits).to include(credit_transaction)
        expect(Transaction.credits).not_to include(debit_transaction, transfer_transaction)
      end
    end

    describe '.debits' do
      it 'returns only debit transactions' do
        expect(Transaction.debits).to include(debit_transaction)
        expect(Transaction.debits).not_to include(credit_transaction, transfer_transaction)
      end
    end

    describe '.transfers' do
      it 'returns only transfer transactions' do
        expect(Transaction.transfers).to include(transfer_transaction)
        expect(Transaction.transfers).not_to include(credit_transaction, debit_transaction)
      end
    end
  end

  describe '#apply!' do
    let(:transaction) { build(:transaction) }

    it 'raises NotImplementedError' do
      expect { transaction.apply! }.to raise_error(NotImplementedError, "Subclasses must define `apply!`")
    end
  end
end
