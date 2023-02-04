# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  has_secure_password

  has_one :account, inverse_of: :user

  validates :email, :name, :password_digest, :cpf, presence: true

  def save
    super

    Account.create!(
      user: self,
      balance: 0
    )
  end
end
