class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :author, null: false
      t.text :text, null: false
      t.timestamps
    end
    add_reference :comments, :job, foreign_key: true
  end
end
