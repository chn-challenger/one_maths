class AddMakerRefToChoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :choices, :maker, foreign_key: true
  end
end
