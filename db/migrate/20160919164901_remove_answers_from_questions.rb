class RemoveAnswersFromQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :answers
  end
end
