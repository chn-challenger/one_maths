class AddStreakMtpToAnsweredQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :answered_questions, :streak_mtp, :float
    add_column :answered_questions, :correctness, :float
  end
end
