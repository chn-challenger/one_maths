module UpdateExp

  def update_correctness(amended_ans_q)
    future_answers = AnsweredQuestion.where(user_id:amended_ans_q.user_id,lesson_id:amended_ans_q.lesson_id, created_at: amended_ans_q.created_at..Time.now)
    # future_answers = AnsweredQuestion.all
    lesson_exp = StudentLessonExp.find_by(lesson_id: amended_ans_q.lesson_id, user_id: amended_ans_q.user_id)


    arr_size = future_answers.size

    # p arr_size

    for i in 0...arr_size-1 do
      # p i
      if arr_size == i
        current_correctness = future_answers[i].correctness
        current_streak_mtp = future_answers[i].streak_mtp

        if current_correctness < 0.99
          lesson_exp.streak_mtp = ((current_streak_mtp - 1) * current_correctness) + 1
        else
          lesson_exp.streak_mtp = min(2,lesson_exp.streak_mtp + 0.25)
        end
        lesson_exp.save!
      else
        current_correctness = future_answers[i].correctness
        current_streak_mtp = future_answers[i].streak_mtp

        puts "current streak is #{current_streak_mtp}"

        next_ans = future_answers[i+1]

        puts "current i+1 is #{i+1}"
        puts "double check current #{future_answers[i+1].streak_mtp}"
        # puts "current object id is #{future_answers[i].object_id}"
        # puts "next object id is #{future_answers[i+1].object_id}"
        puts "current i streak_mtp is #{next_ans.streak_mtp}"
        # p next_ans

        if current_correctness < 0.99
          puts "first one"
          next_ans.streak_mtp = ((current_streak_mtp - 1) * current_correctness) + 1
          next_ans.save!
        else
          puts "second one"
          next_ans.streak_mtp = [2,next_ans.streak_mtp + 0.25].min
          next_ans.save!
          puts next_ans.streak_mtp
        end
        # next_ans.save!
        puts "updated i streak_mtp is #{next_ans.streak_mtp}"
        puts "double check streak_mtp is #{future_answers[i+1].streak_mtp}"
        puts '==================='
      end
    end
  end

end
