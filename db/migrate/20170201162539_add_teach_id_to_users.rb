class AddTeachIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :teacher_id, :integer
  end
end
