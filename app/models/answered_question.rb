class AnsweredQuestion < ApplicationRecord
  serialize :answer, Hash
  validates :user, uniqueness: { scope: [:question, :lesson_id], message: 'You have answered this question already' }
  belongs_to :question
  belongs_to :user
  belongs_to :lesson
  belongs_to :topic
end
