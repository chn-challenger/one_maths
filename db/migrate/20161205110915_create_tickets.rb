class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :title, null: false, default: 'Dummy title'
      t.integer :owner_id, null: false
      t.integer :agent_id
      t.timestamps
    end
  end
end
