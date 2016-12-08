class AddFieldToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :status, :string, null: false, default: 'Test'
  end
end
