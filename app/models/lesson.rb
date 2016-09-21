class Lesson < ApplicationRecord
  belongs_to :topic
  has_and_belongs_to_many :questions

  has_many :current_questions, dependent: :destroy

  has_many :student_lesson_exps, dependent: :destroy
  has_many :users, through: :student_lesson_exps

  def question_orders
    orders = []
    questions.each do |q|
      orders << q.order
    end
    orders.uniq.sort
  end

  def questions_by_order(order)
    result = []
    questions.each do |q|
      if q.order == order
        result << q
      end
    end
    result.sort
  end

  def next_question_order(user)
    answered_questions = []
    AnsweredQuestion.where(user_id:user.id,lesson_id:self.id)
      .sort{|a,b| a.created_at <=> b.created_at}.each do |aq|
        answered_questions << Question.find(aq.question_id)
      end

    if !!answered_questions.last

      last_order = answered_questions.last.order
      last_order_index = question_orders.index(last_order)

      if last_order_index == question_orders.length - 1
        return question_orders.first
      else
        return question_orders[last_order_index + 1]
      end

    else
      return question_orders.first
    end
  end

  def get_next_question_of(order)
    answered_questions = []
    AnsweredQuestion.where(user_id:user.id,lesson_id:self.id)
      .sort{|a,b| a.created_at <=> b.created_at}.each do |aq|
        answered_questions << Question.find(aq.question_id)
      end
    #randomly choose an availble question of this order
    pool = questions_by_order(order)
    availabl_pool = pool - answered_questions

    if availble_pool.length == 0
      return 'all questions of this order has been answered'
    else
      return availabl_pool.sample
    end

  end

  def random_question(user)
    # answered_questions = []
    # user.answered_questions.each do |aq|
    #   # answered_questions << Question.find(a.question_id)
    #   answered_questions << AnsweredQuestion.where(question_id:aq.question_id,lesson_id:self.id).first
    # end
    student_lesson_answered_questions = AnsweredQuestion.where(user_id:user.id,lesson_id:self.id)
    student_lesson_answered_questions.sort!{|a,b| a.created_at <=> b.created_at}

    answered_questions = []
    student_lesson_answered_questions.each do |aq|
      answered_questions << Question.find(aq.question_id)
    end
    last_answered_lesson_question = answered_question.last


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
