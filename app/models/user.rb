# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  has_one :account, inverse_of: :user

  validates :email, :name, :password_digest, :cpf, presence: true

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def save
    super

    Account.create!(
      user: self,
      balance: 0
    )
  end
end
