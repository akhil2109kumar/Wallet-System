FactoryBot.define do
  factory :user do
    name { "Alice" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "securepassword" }
    password_confirmation { "securepassword" }

    # Optionally, you can define a trait for users with a wallet if needed:
    trait :with_wallet do
      after(:create) do |user|
        create(:wallet, walletable: user)
      end
    end
  end
end
