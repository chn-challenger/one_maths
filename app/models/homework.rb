class Homework < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :lesson, optional: true
  belongs_to :topic, optional: true
  # belongs_to :teacher, class_name: 'User', through: :student

  has_many :answered_questions
  has_many :questions, through: :answered_questions
end
