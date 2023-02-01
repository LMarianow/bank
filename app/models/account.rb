class Account < ApplicationRecord
    validates :balance, presence: true
    belongs_to :user
    
    has_many :events

    def deposit(quantity)
        update(balance: balance + quantity.to_f)
        create_event('deposit', "deposit in the value: #{quantity}")
    end
    
    def withdraw(quantity)
        return if verify_balance(quantity)
        update(balance: balance - quantity.to_f)
        create_event('withdraw', "withdraw in the value: #{quantity}")
    end
    
    def transference(quantity, email)
        return if verify_balance(quantity)
        user_dest = User.find_by!(email: email)
        account_dest = user_dest.account
        update(balance: balance - quantity)
        account_dest.update(balance: account_dest.balance + quantity)
        create_event('transference', "transference in the value: #{quantity} to #{user_dest.email}")
    end
    
    private
    
    def verify_balance(quantity)
        raise ArgumentError, 'balance insuficient for the withdraw' if balance - quantity < 0
    end

    def create_event(action, description)
        Event.create(
            action: action,
            description: description,
            account: self
        )
    end
end
