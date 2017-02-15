class AddAnsweredQuestionToHomework < ActiveRecord::Migration[5.0]
  def change
    add_reference :answered_questions, :homework, foreign_key: true
  end
end
