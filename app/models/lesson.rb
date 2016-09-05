class Lesson < ApplicationRecord
  belongs_to :topic
  has_and_belongs_to_many :questions
  has_many :current_questions, dependent: :destroy

  has_many :student_lesson_exps
  has_many :users, through: :student_lesson_exps

  def random_question(user)
    answered_questions = []
    user.answered_questions.each do |a|
      answered_questions << Question.find(a.question_id)
    end
    (questions - answered_questions).sample
    # (questions - user.answered_questions.inject([]){|res,ele| res << Question.find(ele.question_id) }).sample
  end

  # def next_question(user)
  #
  # end

end
