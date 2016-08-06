class AddMakerRefToLessons < ActiveRecord::Migration[5.0]
  def change
    add_reference :lessons, :maker, foreign_key: true
  end
end
