class AddQuestionToTicket < ActiveRecord::Migration[5.0]
  def change
    add_reference :tickets, :question, foreign_key: true
  end
end
