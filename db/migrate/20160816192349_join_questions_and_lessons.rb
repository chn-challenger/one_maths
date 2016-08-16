class JoinQuestionsAndLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons_questions, id: false do |t|
      t.belongs_to :lesson, index: true
      t.belongs_to :question, index: true
    end
  end
end
