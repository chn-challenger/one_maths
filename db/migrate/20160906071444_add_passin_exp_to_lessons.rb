class AddPassinExpToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :pass_experience, :integer
  end
end
