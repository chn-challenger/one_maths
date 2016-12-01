class AddJobToUnits < ActiveRecord::Migration[5.0]
  def change
    add_reference :units, :job, foreign_key: true
  end
end
