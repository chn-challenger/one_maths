class AddQuestionRefToChoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :choices, :question, foreign_key: true
  end
end
