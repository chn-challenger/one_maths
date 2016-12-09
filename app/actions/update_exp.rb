module UpdateExp

  def update_streak_mtp(amended_ans_q)
    future_answers = AnsweredQuestion.where(user_id:amended_ans_q.user_id,
      lesson_id:amended_ans_q.lesson_id, created_at: amended_ans_q.created_at..Time.now)
    for i in 1...future_answers.length do
      next_streak_mtp(future_answers[i-1].correctness,future_answers[i-1].streak_mtp,future_answers[i])
    end
    lesson_exp = StudentLessonExp.find_by(lesson_id: amended_ans_q.lesson_id, user_id: amended_ans_q.user_id)
    next_streak_mtp(future_answers.last.correctness,future_answers.last.streak_mtp,lesson_exp)
  end

  def recalculate_exp(student,lesson)
    future_answers = AnsweredQuestion.where(user_id:student.id,lesson_id:lesson.id)
    lesson_exp = StudentLessonExp.find_by(user_id:student.id,lesson_id:lesson.id)
    lesson_exp.exp = future_answers.inject(0){|res,ans|
      res + ans.question.experience * ans.streak_mtp * ans.correctness}
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


# puts res
# puts "============"
# puts ans.question.experience
# puts ans.streak_mtp
# puts ans.correctness
# puts "============"

    # for i in 0...future_answers.length - 1 do
    #   prev_correctness = future_answers[i].correctness
    #   prev_streak_mtp = future_answers[i].streak_mtp
    #   next_ans = future_answers[i+1]
    #   if prev_correctness < 0.99
    #     next_ans.streak_mtp = ((prev_streak_mtp - 1) * prev_correctness) + 1
    #   else
    #     next_ans.streak_mtp = [NEXT_ANS.streak_mtp + 0.25,2].min
    #   end
    #   next_ans.save!
    # end
