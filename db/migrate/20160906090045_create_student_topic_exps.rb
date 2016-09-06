class CreateStudentTopicExps < ActiveRecord::Migration[5.0]
  def change
    create_table :student_topic_exps do |t|
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :topic_exp

      t.timestamps
    end
  end
end
