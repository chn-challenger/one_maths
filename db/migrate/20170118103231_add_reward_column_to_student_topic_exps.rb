class AddRewardColumnToStudentTopicExps < ActiveRecord::Migration[5.0]
  def change
    add_column :student_topic_exps, :reward_mtp, :float, { null: false, default: 1.0 }
  end
end
