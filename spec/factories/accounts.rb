FactoryBot.define do
  factory :account do
    balance { 0 }
    user { create(:user) }
  end
end