class CreateEventTable < ActiveRecord::Migration[6.0]
    def change
      create_table :events do |t|
        t.string :action, null: false
        t.string :description, null: false
        t.references :account, index: true, foreign_key: { to_table: 'accounts' }
  
        t.timestamps
      end
    end
end