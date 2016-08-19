class AddUserRefToCourses < ActiveRecord::Migration[5.0]
  def change
    add_reference :courses, :user, foreign_key: true
    add_reference :units, :user, foreign_key: true
    add_reference :topics, :user, foreign_key: true
    add_reference :lessons, :user, foreign_key: true
    add_reference :questions, :user, foreign_key: true
    add_reference :choices, :user, foreign_key: true
  end
end
