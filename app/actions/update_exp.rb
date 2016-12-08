module UpdateExp

  def update_correctness(amended_ans_q)
    future_answers = AnsweredQuestion.where(user_id:amended_ans_q.user_id,lesson_id:amended_ans_q.lesson_id, created_at: amended_ans_q.created_at..Time.now)
    # lesson_exp = StudentLessonExp.find_by(lesson_id: amended_ans_q.lesson_id, user_id: amended_ans_q.user_id)
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
