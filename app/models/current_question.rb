class CurrentQuestion < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  belongs_to :question

  validates :user, uniqueness: { scope: [:question, :lesson], message: 'There is a current question for this lesson.' }
end
