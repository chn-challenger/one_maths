class AddStreakMtpToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :streak_mtp, :integer, null: true
  end
end
