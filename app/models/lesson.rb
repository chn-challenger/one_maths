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
    available_questions = questions - answered_questions

    available_questions.sort!{ |a,b| a.order <=> b.order }

    # question_names = []
    # available_questions.each do |q|
    #   question_names << q.question_text
    # end
    # puts ""
    # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    # p available_questions
    # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    # puts ""
    random_number = rand(0...available_questions.length)
    # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    # p random_number
    # p available_questions[random_number]
    # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    picked = available_questions[random_number]
    return picked
  end


  # def random_question(user)
  #   answered_questions = []
  #   user.answered_questions.each do |a|
  #     answered_questions << Question.find(a.question_id)
  #     # puts ""
  #     # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  #     # p answered_questions
  #     # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  #     # puts ""
  #   end
  #   left_questions = questions - answered_questions
  #   # puts ""
  #   # puts "££££££££££££££££££££££££"
  #   # p left_questions
  #   # p left_questions.length
  #   # puts "££££££££££££££££££££££££"
  #   # puts ""
  #   picked = left_questions.sample
  #   # puts ""
  #   # puts "$$$$$$$$$$$$$$$$$$$$$$$$"
  #   # p picked
  #   # puts "$$$$$$$$$$$$$$$$$$$$$$$$"
  #   # puts ""
  #   return picked
  # end

end
