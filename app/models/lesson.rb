class Lesson < ApplicationRecord
  belongs_to :topic
  has_and_belongs_to_many :questions

  has_many :current_questions, dependent: :destroy

  has_many :student_lesson_exps, dependent: :destroy
  has_many :users, through: :student_lesson_exps

  def random_question(user)
    # answered_questions = []
    # user.answered_questions.each do |aq|
    #   # answered_questions << Question.find(a.question_id)
    #   answered_questions << AnsweredQuestion.where(question_id:aq.question_id,lesson_id:self.id).first
    # end
    student_lesson_answered_questions = AnsweredQuestion.where(user_id:user.id,lesson_id:self.id)

    answered_questions = []
    student_lesson_answered_questions.each do |aq|
      answered_questions << Question.find(aq.question_id)
    end


    puts ""
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    p answered_questions
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    puts ""

    available_questions = questions - answered_questions

    available_questions.sort!{ |a,b| a.order <=> b.order }

    #method!!!!!!!!!!!!
    #get the order of the last answered question of the lesson
    #get an array of next order questions - filtered by those already answered
    #if the array is empty, go to the next order, if get to last order and still empty, start from order 1
    #pick from that array


    question_names = []
    available_questions.each do |q|
      question_names << q.question_text
    end
    puts ""
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    p question_names
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts ""
    random_number = rand(0...available_questions.length)
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    p random_number
    p available_questions[random_number]
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
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
