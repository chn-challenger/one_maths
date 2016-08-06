class Unit < ApplicationRecord
  belongs_to :course
  belongs_to :maker
  # has_many :topics
  has_many :topics,
        -> { extending WithMakerAssociationExtension },
        dependent: :destroy
end
