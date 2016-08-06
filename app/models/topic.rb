class Topic < ApplicationRecord
  belongs_to :unit
  belongs_to :maker
  has_many :lessons,
        -> { extending WithMakerAssociationExtension },
        dependent: :destroy
end
