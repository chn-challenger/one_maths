class AddLessonRefToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :lesson, foreign_key: true
  end
end
