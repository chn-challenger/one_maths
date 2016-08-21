class RemoveUserIdFromCourses < ActiveRecord::Migration[5.0]
  def change
    remove_reference :courses, :user, foreign_key: true
    remove_reference :units, :user, foreign_key: true
    remove_reference :topics, :user, foreign_key: true
    remove_reference :lessons, :user, foreign_key: true
    remove_reference :questions, :user, foreign_key: true
    remove_reference :choices, :user, foreign_key: true
  end
end
