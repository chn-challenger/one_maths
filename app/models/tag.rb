class Tag < ApplicationRecord
  has_and_belongs_to_many :images
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :tickets
end
