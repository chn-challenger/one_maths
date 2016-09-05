class AddSortOrderToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :sort_order, :integer
  end
end
