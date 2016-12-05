class AddCommentsToTicket < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :ticket, foreign_key: true
  end
end
