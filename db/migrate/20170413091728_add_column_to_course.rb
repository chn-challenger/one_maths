class AddColumnToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :owner_id, :integer
    add_column :courses, :status, :string
  end
end
