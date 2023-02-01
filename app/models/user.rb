require 'bcrypt'

class User < ApplicationRecord
    include BCrypt

    after_create :create_account

    has_one :account, inverse_of: :user

    validates :email, :name, :password_digest, :cpf, presence: true

    def password
        @password ||= Password.new(password_hash)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.password_digest = @password
    end

    private

    def create_account
        Account.create!(
        user: self,
        balance: 0
        )
    end
end
