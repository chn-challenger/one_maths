class RemoveMakerRefFromCourses < ActiveRecord::Migration[5.0]
  def change
    remove_reference :courses, :maker, foreign_key: true
    remove_reference :units, :maker, foreign_key: true
    remove_reference :topics, :maker, foreign_key: true
    remove_reference :lessons, :maker, foreign_key: true
    remove_reference :questions, :maker, foreign_key: true
    remove_reference :choices, :maker, foreign_key: true
  end
end
