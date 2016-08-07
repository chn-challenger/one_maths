class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :question_text
      t.string :solution

      t.timestamps
    end
  end
end
