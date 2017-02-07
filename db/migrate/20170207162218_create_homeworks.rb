class CreateHomeworks < ActiveRecord::Migration[5.0]
  def change
    create_table :homeworks do |t|
      t.integer :student_id
      t.integer :topic_id
      t.integer :lesson_id
      t.integer :initial_exp
      t.integer :target_exp
      t.datetime :started_on

      t.timestamps
    end

    add_index :homeworks, [:student_id, :topic_id], unique: true, name: 'homework_student_topic_index'
    add_index :homeworks, [:student_id, :lesson_id], unique: true, name: 'homework_student_lesson_index'
  end
end
