class AddStreakMtpToStudentTopicExp < ActiveRecord::Migration[5.0]
  def change
    add_column :student_topic_exps, :streak_mtp, :float
  end
end
