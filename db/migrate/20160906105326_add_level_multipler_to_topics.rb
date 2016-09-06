class AddLevelMultiplerToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :level_multiplier, :float
  end
end
