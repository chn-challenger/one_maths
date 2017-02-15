class AddStudentIdToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :student_id, :integer
  end
end
