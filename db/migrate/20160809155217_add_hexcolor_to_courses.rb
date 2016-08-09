class AddHexcolorToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :hexcolor, :string
  end
end
