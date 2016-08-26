class Topic < ApplicationRecord
  belongs_to :unit
  has_many :lessons, dependent: :destroy
  has_and_belongs_to_many :questions
end
