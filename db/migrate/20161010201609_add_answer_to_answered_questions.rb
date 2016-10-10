class AddAnswerToAnsweredQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :answered_questions, :answer, :string
  end
end
