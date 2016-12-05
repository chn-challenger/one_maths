class AddFieldToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :status, :string, null: false, default: 'Open'
  end
end
