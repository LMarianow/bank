class Account < ApplicationRecord
    validates :balance, presence: true
end
