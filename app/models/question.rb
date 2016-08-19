class Question < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :lessons

  has_many :choices,
        -> { extending WithUserAssociationExtension },
        dependent: :destroy

end
