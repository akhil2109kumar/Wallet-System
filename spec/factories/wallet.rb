FactoryBot.define do
  factory :wallet do
    balance { 1000 }
    association :walletable, factory: :user

    trait :for_user do
      association :walletable, factory: :user
    end

    trait :for_team do
      association :walletable, factory: :team
    end
  end
end
