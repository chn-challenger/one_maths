class Lesson < ApplicationRecord
  belongs_to :maker
  belongs_to :topic
  has_many :questions,
        -> { extending WithMakerAssociationExtension },
        dependent: :destroy
end
