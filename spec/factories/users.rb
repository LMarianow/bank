FactoryBot.define do
    factory :person do
      name { Faker::Name.name }
      email { Faker::Name.name }
      password_digest { Faker::Name.name  }
      cpf { Faker::Name.name  }
    end
  end