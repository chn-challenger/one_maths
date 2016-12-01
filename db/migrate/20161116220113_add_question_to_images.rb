class AddQuestionToImages < ActiveRecord::Migration[5.0]
  def change
    add_reference :images, :question, foreign_key: true
  end
end
