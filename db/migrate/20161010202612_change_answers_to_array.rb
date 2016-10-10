class ChangeAnswersToArray < ActiveRecord::Migration[5.0]
  def change
    change_column :answered_questions, :answer,  :text
  end
end
