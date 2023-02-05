FactoryBot.define do
  factory :account do
    balance { 0 }
    user { create(:user) }
    status { 'open' }
  end
end