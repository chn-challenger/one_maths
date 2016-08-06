class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :description
      t.string :video

      t.timestamps
    end
  end
end
