class CreateTicketsQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets_questions, id: false do |t|
      t.belongs_to :ticket, index: true
      t.belongs_to :question, index: true
    end
  end
end
