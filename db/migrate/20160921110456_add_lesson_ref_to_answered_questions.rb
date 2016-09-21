class AddLessonRefToAnsweredQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :answered_questions, :lesson, foreign_key: true
  end
end
