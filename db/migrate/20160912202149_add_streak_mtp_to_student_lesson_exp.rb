class AddStreakMtpToStudentLessonExp < ActiveRecord::Migration[5.0]
  def change
    add_column :student_lesson_exps, :streak_mtp, :float
  end
end
