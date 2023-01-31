FactoryBot.define do
  factory :event do
    action { 'withdraw'}
    description { "withdraw in the value: 50" }
    association :account, factory: :account
  end
end