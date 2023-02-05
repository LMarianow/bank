# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  has_secure_password

  has_one :account, inverse_of: :user, dependent: :destroy

  validates :email, :name, :password_digest, :cpf, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def save
    super

    Account.create!(
      user: self,
      balance: 0
    )
  end
end
