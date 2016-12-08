module TicketSupport

  def get_unit_id(question)
    question.lessons.first.topic.unit.id
  end

  def amend_exp(ticket)
    student = ticket.owner
    question = ticket.questions.first
    ans_q = AnsweredQuestion.find_by(question_id: question.id, user_id: student.id)

    lesson_id = ans_q.blank? ? question.lessons.first.id : ans_q.lesson_id

    lesson_exp = StudentLessonExp.find_by(lesson_id: lesson_id, user_id: student.id)

    return if lesson_exp.blank?
    award_exp = question.experience * 2
    lesson_exp.exp += award_exp
    lesson_exp.save!
    award_exp
  end

end
