# frozen_string_literal: true

class Account < ApplicationRecord
  validates :balance, presence: true
  belongs_to :user

  has_many :events

  before_destroy :avoid_destroy

  def deposit(quantity)
    update(balance: balance + quantity.to_f)
    create_event('deposit', "deposit in the value: #{quantity}")
  end

  def withdraw(quantity)
    return if verify_balance(quantity.to_f, 'withdraw')

    update(balance: balance - quantity.to_f)
    create_event('withdraw', "withdraw in the value: #{quantity}")
  end

  def transference(quantity, email)
    quantity_with_tax = tax_por_hour(quantity.to_f)

    return if verify_balance(quantity_with_tax, 'transference')


    user_dest = User.find_by!(email: email)
    account_dest = user_dest.account

    update(balance: balance - quantity_with_tax)

    account_dest.update(balance: account_dest.balance + quantity)
    create_event('transference', "transference in the value: #{quantity} to #{user_dest.email}")
  end

  private

  def tax_por_hour(quantity)
    hour_now = DateTime.now

    tax = 0.0

    tax += 10 if quantity > 1000

    return quantity + (tax + 5) if hour_now.utc.strftime( "%H%M%S%N" ) >= "090000" && hour_now.utc.strftime( "%H%M%S%N" ) <= "180000"

    quantity + (tax + 7)
  end

  def verify_balance(quantity, action)
    raise ArgumentError, "balance insuficient for the #{action}" if balance - quantity < 0
  end

  def create_event(action, description)
    Event.create(
        action: action,
        description: description,
        account: self
    )
  end

  def avoid_destroy
    raise StandardError, "it doesnt destroy account"
  end
end
