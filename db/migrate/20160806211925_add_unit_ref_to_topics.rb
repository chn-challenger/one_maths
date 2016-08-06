class AddUnitRefToTopics < ActiveRecord::Migration[5.0]
  def change
    add_reference :topics, :unit, foreign_key: true
  end
end
