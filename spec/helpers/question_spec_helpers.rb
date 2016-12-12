def create_question(number, lesson=nil)
  question = Question.new(question_text:"question text #{number}",
    solution:"solution #{number}", order: 1, experience: 100)
  question.save!
  unless lesson.nil?
    lesson.questions << question
  end
  question
end

def create_question_with_order(number,order)
  Question.create(question_text:"question text #{number}",
    solution:"solution #{number}", experience: 100, order: order)
end

def create_question_with_order_exp(number,order,exp)
  Question.create(question_text:"question text #{number}",
    solution:"solution #{number}", experience: exp, order: order)
end

def create_answered_question(student, question, correctness = true, created_on = Time.now)
  ansq = AnsweredQuestion.new(user: student, question: question, correct: correctness, created_at: created_on)
  return fail 'AnsweredQuestion did not save!' unless ansq.save!
end

def create_answered_question_manager(student, question, lesson, correctness = true)
  ansq = AnsweredQuestion.new(user: student, question: question, correct: correctness, lesson_id: lesson.id)
  return fail 'AnsweredQuestion did not save!' unless ansq.save!
end
