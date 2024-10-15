FactoryBot.define do
  factory :transaction do
    amount { 100 }
    type { "Credit" }

    association :source_wallet, factory: :wallet
    association :target_wallet, factory: :wallet
  end
end
