class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.decimal :balance,null:false
      t.string :status, null: false, default: 'open'

      t.timestamps
    end
  end
end
