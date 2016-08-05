class AddMakerRefToCourses < ActiveRecord::Migration[5.0]
  def change
    add_reference :courses, :maker, foreign_key: true
  end
end
