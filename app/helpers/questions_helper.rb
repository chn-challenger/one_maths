module QuestionsHelper
  def standardise_answer(answer)
    answer.gsub(/[A-Za-z]|[ \t\r\n\v\f]/,"").split(',').map! do |num|
      '%.2f' % ((num.to_f * 100).round / 100.0)
    end.sort
  end

  def standardise_param_answers(params)
    params_answers = {}
    if !!params[:js_answers]
      params[:js_answers].each do |index,array|
        params_answers[array[0]] = array[1]
      end
    else
      params_answers = params[:answers]
    end
    params_answers
  end

  def answer_result(params,params_answers)
    question = Question.find(params[:question_id])
    if !!params[:choice]
      correct = Choice.find(params[:choice]).correct
    else
      question_answers = {}
      question.answers.each do |answer|
        question_answers[answer.label] = answer.solution
      end
      correct = true
      params_answers.each do |label,answer|
        #replace if condition with customized version
        # correct = false if question_answers[label] != answer
        correct_answer = standardise_answer(question_answers[label])
        student_answer = standardise_answer(answer)
        correct = false if correct_answer != student_answer
      end
    end
    return correct
  end

  def record_answered_question(current_user,correct,params)
    AnsweredQuestion.create(user_id:current_user.id,question_id:
      params[:question_id],correct:correct,lesson_id:params[:lesson_id])
  end

  def get_student_lesson_exp(current_user,params)
    StudentLessonExp.where(user_id: current_user.id, lesson_id: params[:lesson_id]).first ||
      StudentLessonExp.create(user_id: current_user.id, lesson_id: params[:lesson_id], exp: 0, streak_mtp: 1)
  end

  def get_student_topic_exp(current_user,topic)
    StudentTopicExp.where(user_id: current_user.id, topic_id: topic.id ).first ||
      StudentTopicExp.create(user_id: current_user.id, topic_id: topic.id, exp: 0, streak_mtp: 1)
  end

  def update_exp(correct,experience,question,streak_mtp)
    if correct
      experience.exp += (question.experience * streak_mtp)
      experience.save
    end
  end

  def update_exp_streak_mtp(correct,experience)
    if correct
      experience.streak_mtp *= 1.2
      experience.streak_mtp = 2 if experience.streak_mtp > 2
    else
      experience.streak_mtp = 1
    end
    experience.save
  end

  def result_message(correct)
    correct ? "Correct answer! Well done!" : "Incorrect, have a look at the solution and try another question!"
  end

  def result_json(result,question,correct,params,current_user,topic,solution_image_url)
    # topic = Lesson.find(params[:lesson_id]).topic
    {
      message: result,
      question_solution: question.solution,
      solution_image_url: solution_image_url,
      choice: correct,
      lesson_exp: StudentLessonExp.current_exp(current_user,params[:lesson_id]),
      topic_exp: StudentTopicExp.current_level_exp(current_user,topic),
      topic_next_level_exp: StudentTopicExp.next_level_exp(current_user,topic),
      topic_next_level: StudentTopicExp.current_level(current_user,topic) + 1
    }
  end

  def correctness(params,params_answers)
    question = Question.find(params[:question_id])
    correct = 0
    unless !!params[:choice]
      question_answers = {}
      question.answers.each{|ans| question_answers[ans.label] = ans.solution}

      increment = 1.0/question_answers.length
      question_answers.each do |label,answer|
        correct_answer = standardise_answer(answer)
        student_answer = standardise_answer(params_answers[label])
        if correct_answer == student_answer
          correct += increment
        else
          increment_increment = increment / correct_answer.length
          to_add = 0
          correct_answer.each{|ans| to_add += increment_increment if
            student_answer.include?(ans)}
          to_add = [to_add - increment_increment * (student_answer.length
            - correct_answer.length),0].min if
            student_answer.length > correct_answer.length
          correct += to_add
        end
      end
    end
    return correct
  end

  def update_partial_exp(correctness,experience,question,streak_mtp)
    if correctness > 0 && correctness < 0.99
      experience.exp += (question.experience * correctness * streak_mtp)
      experience.save
    end
  end

end
