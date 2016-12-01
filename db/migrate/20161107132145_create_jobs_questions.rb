class CreateJobsQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs_questions do |t|
      t.references :question, foreign_key: true
      t.references :job, foreign_key: true
    end
  end
end
