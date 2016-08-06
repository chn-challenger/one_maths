class AddMakerRefToTopics < ActiveRecord::Migration[5.0]
  def change
    add_reference :topics, :maker, foreign_key: true
  end
end
