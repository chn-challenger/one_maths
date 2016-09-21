class AddOrderToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :order, :string
  end
end
