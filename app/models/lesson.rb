class Lesson < ApplicationRecord
  belongs_to :topic
  has_and_belongs_to_many :questions

  has_many :current_questions, dependent: :destroy

  has_many :student_lesson_exps, dependent: :destroy
  has_many :users, through: :student_lesson_exps

  def random_question(user)
    answered_questions = []
    user.answered_questions.each do |a|
      answered_questions << Question.find(a.question_id)
    end
    left_questions = questions - answered_questions
    # puts "££££££££££££££££££££££££"
    # p left_questions
    # p left_questions.length
    # puts "££££££££££££££££££££££££"
    picked = left_questions.sample
    # puts "$$$$$$$$$$$$$$$$$$$$$$$$"
    # p picked
    # puts "$$$$$$$$$$$$$$$$$$$$$$$$"
    return picked
  end

end
