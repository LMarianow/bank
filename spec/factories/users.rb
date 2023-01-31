FactoryBot.define do
    factory :user do
      name { Faker::Name.name }
      email { Faker::Internet.email}
      password_digest { Faker::Crypto.sha1  }
      cpf { Faker::Alphanumeric.alpha(number: 10)  }
      # association :account, factory: :account
      # account { create(:account) }
    end
  end