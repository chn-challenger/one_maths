class CreateTicketsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags_tickets, id: false do |t|
      t.belongs_to :ticket, index: true
      t.belongs_to :tag, index: true
    end
  end
end
