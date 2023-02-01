class Account < ApplicationRecord
    validates :balance, presence: true
    belongs_to :user

    def deposit(quantity)
        update(balance: balance + quantity.to_f)
    end
    
    def withdraw(quantity)
        return if verify_balance(quantity)
        update(balance: balance - quantity.to_f)
    end
    
    def transference(quantity, email)
        return if verify_balance(quantity)
        user_dest = User.find_by!(email: email)
        account_dest = user_dest.account
        self.update(balance: balance - quantity)
        account_dest.update(balance: account_dest.balance + quantity)
    end
    
    private
    
    def verify_balance(quantity)
        raise ArgumentError, 'balance insuficient for the withdraw' if balance - quantity < 0
    end
end
