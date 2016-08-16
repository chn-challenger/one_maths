class Question < ApplicationRecord
  belongs_to :maker
  has_and_belongs_to_many :lessons

  has_many :choices,
        -> { extending WithMakerAssociationExtension },
        dependent: :destroy

end
