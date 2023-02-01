class AddUserToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :user, foreign_key: true, index: true
    add_index :accounts, %i[id user_id ], unique: true
  end
end
