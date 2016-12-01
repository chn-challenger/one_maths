class AddJobToImages < ActiveRecord::Migration[5.0]
  def change
    add_reference :images, :job, foreign_key: true
  end
end
