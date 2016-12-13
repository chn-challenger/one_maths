class Ticket < ApplicationRecord
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :questions, class_name: "Question", join_table: "tickets_questions"
  has_many :comments, class_name: 'Comment' , dependent: :destroy
  belongs_to :agent, class_name: "User", foreign_key: :agent_id
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
end
