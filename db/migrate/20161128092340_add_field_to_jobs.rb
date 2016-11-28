class AddFieldToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :completed_by, :integer
  end
end
