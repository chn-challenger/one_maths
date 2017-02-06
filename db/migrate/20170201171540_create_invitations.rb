class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.integer :invitee_id
      t.integer :sender_id

      t.timestamps
    end

    add_index  :invitations, [:invitee_id, :sender_id], unique: true, name: 'invitee_sender_index'
  end
end
