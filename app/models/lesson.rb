class Lesson < ApplicationRecord
  belongs_to :topic
  has_and_belongs_to_many :questions

  has_many :current_questions, dependent: :destroy

  has_many :student_lesson_exps, dependent: :destroy
  has_many :users, through: :student_lesson_exps

  def question_orders
    questions.inject([]){|arry,q| arry << q.order}.uniq.sort
  end

  def questions_by_order(order)
    questions.inject([]){|arry,q| q.order == order ? arry << q : arry}.sort
  end

  def user_answered_questions(user)
    answered_questions = []
    AnsweredQuestion.where(user_id:user.id,lesson_id:self.id)
      .sort{|a,b| a.created_at <=> b.created_at}.each do |aq|
        answered_questions << Question.find(aq.question_id)
      end
    answered_questions
  end

  def next_question_order(user)
    last_answered_question = AnsweredQuestion.where(user_id:user.id,lesson_id:self.id)
      .sort{|a,b| a.created_at <=> b.created_at}.last

    last_question_correct = true
    if !!last_answered_question && last_answered_question.correct == false
      last_question_correct = false
    end

    answered_questions = user_answered_questions(user)
    if !!answered_questions.last
      last_order = answered_questions.last.order
      last_order_index = question_orders.index(last_order)

      if last_order_index == question_orders.length - 1 && last_question_correct == true
        return question_orders.first
      end

      if last_order_index != question_orders.length - 1 && last_question_correct == true
        return question_orders[last_order_index + 1]
      end

      if last_question_correct == false
        return question_orders[last_order_index]
      end

    else
      return question_orders.first
    end
  end

  def available_next_question_order(order,user)
    return nil if (questions - user_answered_questions(user)).length == 0
    if (questions_by_order(order) - user_answered_questions(user)).length == 0
      order_index = question_orders.index(order)
      if order_index == question_orders.length - 1
        return available_next_question_order(question_orders.first,user)
      else
        return available_next_question_order(question_orders[order_index + 1],user)
      end
    else
      return order
    end
  end

  def get_next_question_of(order,user)
    (questions_by_order(order) - user_answered_questions(user)).sample
  end

  def random_question(user)
    default_order
    preliminary_next_order = next_question_order(user)
    order = available_next_question_order(preliminary_next_order,user)
    !!order ? get_next_question_of(order,user) : nil
  end

  def default_order
    questions.each do |q|
      if q.order == nil
        q.order = ""
        q.save
      end
    end
  end

end
