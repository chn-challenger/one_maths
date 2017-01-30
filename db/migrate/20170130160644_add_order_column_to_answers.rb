class AddOrderColumnToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :order, :integer
    add_index  :answers, [:order, :question_id], unique: true, name: 'order_question_index'
  end
end
