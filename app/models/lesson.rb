class Lesson < ApplicationRecord
  belongs_to :topic
  has_and_belongs_to_many :questions
  has_many :current_questions

  def random
    offset = rand(questions.count)
    questions.offset(offset).first
  end

  def random_question(user)
    answered_questions = []
    user.answered_questions.each do |a|
      answered_questions << Question.find(a.question_id)
    end
    (questions - answered_questions).sample
    # (questions - user.answered_questions.inject([]){|res,ele| res << Question.find(ele.question_id) }).sample
  end

end
