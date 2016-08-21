class Question < ApplicationRecord
  has_and_belongs_to_many :lessons

  has_many :choices, dependent: :destroy

end
