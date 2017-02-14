class RemoveStudentIdFromLessons < ActiveRecord::Migration[5.0]
  def change
    remove_column :lessons, :student_id, :integer
  end
end
