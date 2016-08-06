class AddTopicRefToLessons < ActiveRecord::Migration[5.0]
  def change
    add_reference :lessons, :topic, foreign_key: true
  end
end
