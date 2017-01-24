class AddTopicToAnsweredQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :answered_questions, :topic_id, :integer
  end
end
