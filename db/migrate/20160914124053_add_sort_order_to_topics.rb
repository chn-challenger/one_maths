class AddSortOrderToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :sort_order, :integer
  end
end
