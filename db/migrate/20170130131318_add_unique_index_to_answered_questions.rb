class AddUniqueIndexToAnsweredQuestions < ActiveRecord::Migration[5.0]
  def change
    add_index :answered_questions, [:question_id, :lesson_id, :user_id], unique: true, name: 'question_lesson_user_index'
  end
end
