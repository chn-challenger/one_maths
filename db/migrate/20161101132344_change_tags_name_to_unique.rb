class ChangeTagsNameToUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :tags, :name, unique: true
  end
end
