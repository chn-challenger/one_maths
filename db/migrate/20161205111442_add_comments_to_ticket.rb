class AddCommentsToTicket < ActiveRecord::Migration[5.0]
  def change
    add_reference :tickets, :comment, foreign_key: true
  end
end
