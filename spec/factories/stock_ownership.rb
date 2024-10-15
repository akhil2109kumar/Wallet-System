FactoryBot.define do
  factory :stock_ownership do
    stock
    association :owner, factory: :user  # Default owner is a user
    quantity { 10 }

    trait :with_team_owner do
      association :owner, factory: :team
    end
  end
end
