class AddJobToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :job, foreign_key: true
  end
end
