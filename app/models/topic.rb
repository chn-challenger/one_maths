class Topic < ApplicationRecord
  belongs_to :unit
  belongs_to :user
  has_many :lessons,
        -> { extending WithUserAssociationExtension },
        dependent: :destroy
end
