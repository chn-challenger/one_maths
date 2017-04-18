class AddColumnToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :creator_id, :integer
  end
end
