class Account < ApplicationRecord
    validates :balance, presence: true
    belongs_to :user
end
