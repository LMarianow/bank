FactoryBot.define do
    factory :account do
      balance { 0.5 }
      association :user, factory: :user
    end
  end