class Topic < ApplicationRecord
  belongs_to :unit
  has_many :lessons, dependent: :destroy
  has_and_belongs_to_many :questions

  has_many :student_topic_exps
  has_many :users, through: :student_topic_exps

end
