class AddLevelAndExpToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :difficulty_level, :integer
    add_column :questions, :experience, :integer
  end
end
