class AddFieldsToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :duration, :integer
    add_column :jobs, :status, :string
    add_column :jobs, :price, :float
    add_column :jobs, :creator_id, :integer
    add_column :jobs, :worker_id, :integer
  end
end
