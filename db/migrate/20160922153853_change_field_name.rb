class ChangeFieldName < ActiveRecord::Migration[5.0]
  def change
    rename_column :student_lesson_exps, :lesson_exp, :exp
    rename_column :student_topic_exps, :topic_exp, :exp
  end
end
