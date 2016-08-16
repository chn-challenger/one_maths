class Lesson < ApplicationRecord
  belongs_to :maker
  belongs_to :topic
  has_and_belongs_to_many :questions,
        -> { extending WithMakerAssociationExtension },
        dependent: :destroy

  def random
    offset = rand(questions.count)
    questions.offset(offset).first
  end

end
