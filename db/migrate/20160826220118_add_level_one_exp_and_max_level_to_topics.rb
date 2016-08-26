class AddLevelOneExpAndMaxLevelToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :level_one_exp, :integer
    add_column :topics, :max_level, :integer
  end
end
