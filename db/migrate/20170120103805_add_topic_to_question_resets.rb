class AddTopicToQuestionResets < ActiveRecord::Migration[5.0]
  def change
    add_column :question_resets, :topic_id, :integer
  end
end
