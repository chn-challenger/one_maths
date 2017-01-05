class CreateQuestionResets < ActiveRecord::Migration[5.0]
  def change
    create_table :question_resets do |t|
      t.references :user, foreign_key: true
      t.integer :lesson_id
      t.integer :question_id
      t.integer :count

      t.timestamps
    end
  end
end
