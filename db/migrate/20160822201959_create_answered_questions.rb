class CreateAnsweredQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :answered_questions do |t|
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :correct

      t.timestamps
    end
  end
end
