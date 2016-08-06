class AddMakerRefToUnits < ActiveRecord::Migration[5.0]
  def change
    add_reference :units, :maker, foreign_key: true
  end
end
