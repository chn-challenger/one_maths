class RemoveLessonIdfromQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :lesson_id
  end
end
