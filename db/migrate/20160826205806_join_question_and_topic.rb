class JoinQuestionAndTopic < ActiveRecord::Migration[5.0]
  def change
    create_table :questions_topics, id: false do |t|
      t.belongs_to :topic, index: true
      t.belongs_to :question, index: true
    end
  end
end
