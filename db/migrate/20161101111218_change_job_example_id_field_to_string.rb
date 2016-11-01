class ChangeJobExampleIdFieldToString < ActiveRecord::Migration[5.0]
  def change
    change_column :jobs, :example_id,  :string
  end
end
