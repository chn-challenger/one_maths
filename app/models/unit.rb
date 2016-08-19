class Unit < ApplicationRecord
  belongs_to :course
  belongs_to :user
  has_many :topics,
        -> { extending WithUserAssociationExtension },
        dependent: :destroy
end
