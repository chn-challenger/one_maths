class AnsweredQuestion < ApplicationRecord
  serialize :answer, Hash
  validates :user, uniqueness: { scope: :question, message: 'You have answered this question already' }
  belongs_to :question
  belongs_to :user
end
