class AddSortOrderToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :sort_order, :integer
  end
end
