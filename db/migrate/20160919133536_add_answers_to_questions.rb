class AddAnswersToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :answers, :text
  end
end
