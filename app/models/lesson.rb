class Lesson < ApplicationRecord
  belongs_to :maker
  belongs_to :topic
  has_many :questions,
        -> { extending WithMakerAssociationExtension },
        dependent: :destroy

  def random_question
    offset = rand(questions.count)
    question = questions.offset(offset).first
    if question
      {question: question.question_text,solution: question.solution,
        question_id: question.id}
    else
      {question: "",solution: "",question_id:""}
    end
  end

  def random
    offset = rand(questions.count)
    questions.offset(offset).first
  end

end
