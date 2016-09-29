class CreateChoicesAndImages < ActiveRecord::Migration[5.0]
  def change
    create_table :choices_images, id: false do |t|
      t.belongs_to :choice, index: true
      t.belongs_to :image, index: true
    end
  end
end
