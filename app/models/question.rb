class Question < ApplicationRecord
  belongs_to :maker
  belongs_to :lesson
  has_many :choices,
        -> { extending WithMakerAssociationExtension },
        dependent: :destroy

end
