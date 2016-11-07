class CreateImagesAndTags < ActiveRecord::Migration[5.0]
  def change
    create_table :images_tags, id: false do |t|
      t.belongs_to :image, index: true
      t.belongs_to :tag, index: true
    end
  end
end
