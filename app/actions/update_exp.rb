module UpdateExp

  def amend_exp(ticket, correctness)
    student = ticket.owner
    question = ticket.questions.first
    ans_q = AnsweredQuestion.find_by(question_id: question.id, user_id: student.id)

    return if ans_q.blank?

    if correctness < 0.99
      ans_q.update_attributes(correctness: correctness)
    else
      ans_q.update_attributes(correctness: correctness, correct: true)
    end

    update_streak_mtp(ans_q)

    lesson = Lesson.find(ans_q.lesson_id)
    recalculate_exp(student, lesson)
  end

  def update_streak_mtp(amended_ans_q)
    future_answers = AnsweredQuestion.where(user_id:amended_ans_q.user_id,
      lesson_id:amended_ans_q.lesson_id, created_at: amended_ans_q.created_at..Time.now)
      .order(created_at: :asc)

    for i in 1...future_answers.length do
      p future_answers[i-1].streak_mtp
      next_streak_mtp(future_answers[i-1].correctness,future_answers[i-1].streak_mtp,future_answers[i])
    end
    lesson_exp = StudentLessonExp.find_by(lesson_id: amended_ans_q.lesson_id, user_id: amended_ans_q.user_id)
    next_streak_mtp(future_answers.last.correctness,future_answers.last.streak_mtp,lesson_exp)
  end

  def recalculate_exp(student,lesson)
    future_answers = AnsweredQuestion.where(user_id:student.id,lesson_id:lesson.id)
    lesson_exp = StudentLessonExp.find_by(user_id:student.id,lesson_id:lesson.id)

    lesson_exp.exp = future_answers.inject(0) do |res,ans|
      res + ans.question.experience * ans.streak_mtp * ans.correctness
    end
    lesson_exp.save!
  end

  private

  def next_streak_mtp(last_correctness,last_streak_mtp,object_to_update)
    if last_correctness < 0.99
      object_to_update.streak_mtp = ((last_streak_mtp - 1) * last_correctness ) + 1
    else
      object_to_update.streak_mtp = [last_streak_mtp + 0.25,2].min
    end
    object_to_update.save!
  end

end
