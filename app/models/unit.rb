class Unit < ApplicationRecord
  belongs_to :course
  has_many :topics, dependent: :destroy

  belongs_to :job
end
