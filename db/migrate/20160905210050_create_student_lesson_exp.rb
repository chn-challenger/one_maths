class CreateStudentLessonExp < ActiveRecord::Migration[5.0]
  def change
    create_table :student_lesson_exps do |t|
      t.references :lesson, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :lesson_exp

      t.timestamps
    end
  end
end
