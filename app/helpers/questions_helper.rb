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

  def get_student_lesson_exp(current_user,params)
    StudentLessonExp.where(user_id: current_user.id, lesson_id: params[:lesson_id]).first ||
      StudentLessonExp.create(user_id: current_user.id, lesson_id: params[:lesson_id], lesson_exp: 0, streak_mtp: 1)
  end

  def get_student_topic_exp(current_user,topic)
    StudentTopicExp.where(user_id: current_user.id, topic_id: topic.id ).first ||
      StudentTopicExp.create(user_id: current_user.id, topic_id: topic.id, topic_exp: 0, streak_mtp: 1)
  end

  def update_main_exps(correct,student_exp,question)
    if correct
      result = "Correct answer! Well done!"
      student_exp.topic_exp += (question.experience * student_exp.streak_mtp)
      student_exp.streak_mtp *= 1.2
      if student_exp.streak_mtp > 2
        student_exp.streak_mtp = 2
      end
      student_exp.save
    else
      result = "Incorrect, have a look at the solution and try another question!"
      student_exp.streak_mtp = 1
      student_exp.save
    end
    result
  end
  #
  # def update_next_level_exps(correct,next_level_exp,question)
  #
  # end

  # def update_exp(correct,exp,question)
  #   if correct
  #     exp.topic_exp += (question.experience * student_exp.streak_mtp)
  #     student_exp.streak_mtp *= 1.2
  #     if student_exp.streak_mtp > 2
  #       student_exp.streak_mtp = 2
  #     end
  #     student_exp.save
  #   else
  #     result = "Incorrect, have a look at the solution and try another question!"
  #     student_exp.streak_mtp = 1
  #     student_exp.save
  #   end
  # end
  #
  # def update_exp_streak_mtp
  #
  # end



end

# standard_answer = answer.gsub(/[A-Za-z]|[ \t\r\n\v\f]/,"").split(',')
# standard_answer.map! do |num|
#   n = (num.to_f * 100).round / 100.0
#   '%.2f' % n
# end
# standard_answer.sort!
# standard_answer
# if correct
#   result = "Correct answer! Well done!"
#   student_topic_exp.topic_exp += (question.experience * student_topic_exp.streak_mtp)
#   student_topic_exp.streak_mtp *= 1.2
#   if student_topic_exp.streak_mtp > 2
#     student_topic_exp.streak_mtp = 2
#   end
#   student_topic_exp.save
# else
#   result = "Incorrect, have a look at the solution and try another question!"
#   student_topic_exp.streak_mtp = 1
#   student_topic_exp.save
# end
