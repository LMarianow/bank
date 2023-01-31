# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :account

  validates :action, :description, presence: true

  enum action: {
    withdraw: 'withdraw',
    deposit: 'deposit',
    transference:  'transference'
  }

end