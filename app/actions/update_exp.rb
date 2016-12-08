module UpdateExp

  def update_streak_mtp(amended_ans_q)
    future_answers = AnsweredQuestion.where(user_id:amended_ans_q.user_id,lesson_id:amended_ans_q.lesson_id, created_at: amended_ans_q.created_at..Time.now)
    for i in 1...future_answers.length do
      prev_correctness = future_answers[i-1].correctness
      prev_streak_mtp = future_answers[i-1].streak_mtp
      next_ans = future_answers[i]
      if prev_correctness < 0.99
        next_ans.streak_mtp = ((prev_streak_mtp - 1) * prev_correctness ) + 1
      else
        next_ans.streak_mtp = [prev_streak_mtp + 0.25,2].min
      end
      next_ans.save!
    end
    lesson_exp = StudentLessonExp.find_by(lesson_id: amended_ans_q.lesson_id, user_id: amended_ans_q.user_id)
    last_correctness = future_answers.last.correctness
    last_streak_mtp = future_answers.last.streak_mtp
    if last_correctness < 0.99
      lesson_exp.streak_mtp = ((last_streak_mtp - 1) * last_correctness ) + 1
    else
      lesson_exp.streak_mtp = [last_streak_mtp + 0.25,2].min
    end
    lesson_exp.save!
  end

end




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
