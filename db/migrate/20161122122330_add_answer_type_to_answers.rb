class AddAnswerTypeToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :answer_type, :string, default: "normal"
  end
end
