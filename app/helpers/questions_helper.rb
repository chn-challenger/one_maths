module QuestionsHelper

  def self.included(klass)
    klass.class_eval do
      include InputProcessorHelper
    end
  end

  def get_example_question(question_id)
    job_id = Question.find(question_id).job_id
    return nil unless !job_id.nil?
      Job.find(job_id).examples.first
  end

  def standardise_param_answers(params)
    params_answers = {}
    if !params[:js_answers].blank?
      params[:js_answers].each do |_index, array|
        params_answers[array[0]] = array[1]
      end
    else
      params_answers = params[:answers]
    end
    params_answers
  end

  def get_question(params)
    Question.find(params[:question_id])
  end

  def get_question_answers(params)
    question = get_question(params)
    question_answers = {}
    question.answers.each do |answer|
      question_answers[answer.label] = {
        solution: answer.solution,
        answer_type: answer.answer_type
      }
    end
    question_answers
  end

  def deconstruct(question_answers, params_answers = nil)
    question_answers.each do |label, answer|
      answer_type = answer[:answer_type]
      question_answer = answer[:solution]
      student_answer = params_answers[label]
      yield(answer_type, question_answer, student_answer)
    end
  end

  def answer_result(params, params_answers)
    if !!params[:choice]
      correct = Choice.find(params[:choice]).correct
    else
      question_answers = get_question_answers(params)
      correct = true
      deconstruct(question_answers, params_answers) do |ans_type, q_ans, student_answer|
        correct = false unless standardise_answer(ans_type, q_ans, student_answer) == 1
      end
    end
    correct
  end

  def correctness(params, params_answers)
    correct = 0
    unless !!params[:choice]
      question_answers = get_question_answers(params)

      single_answer_value = 1.0 / question_answers.length

      deconstruct(question_answers, params_answers) do |ans_type, q_ans, student_answer|
        correct += single_answer_value * standardise_answer(ans_type, q_ans, student_answer)
      end
    end
    correct
  end

  def record_answered_question(current_user, correct, params, params_answers, streak_mtp, correctness)
    answer_hash = {}
    answer_type_options = params[:topic_id].blank? ? [:lesson_id, params[:lesson_id]] : [:topic_id, params[:topic_id]]
    params_answers.each { |key, value| answer_hash[key] = value } if !params_answers.blank?

    AnsweredQuestion.create(user_id: current_user.id, question_id: params[:question_id],
                            correct: correct, answer: answer_hash,
                            streak_mtp: streak_mtp, correctness: correctness,
                            answer_type_options[0] => answer_type_options[1])
  end

  def get_student_lesson_exp(current_user, params)
    StudentLessonExp.where(user_id: current_user.id, lesson_id: params[:lesson_id])
                    .first_or_create(user_id: current_user.id, lesson_id: params[:lesson_id],
                                     exp: 0, streak_mtp: 1)
  end

  def get_student_topic_exp(current_user, topic)
    StudentTopicExp.where(user_id: current_user.id, topic_id: topic.id)
                   .first_or_create(user_id: current_user.id, topic_id: topic.id,
                                    exp: 0, streak_mtp: 1)
  end

  def update_lesson_exp(correct, lesson_exp, question)
    return unless correct
    calculated_exp = calculate_exp(lesson_exp, question)

    lesson_exp.exp += calculated_exp
    lesson_exp.save
  end

  def update_topic_exp(correct, lesson_exp, topic_exp, question, topic_question=false)
    return unless correct
    calculated_exp = if topic_question
        calculate_topic_exp(topic_exp, question)
      else
        calculate_exp(lesson_exp, question, 1)
      end

    topic_exp.exp += calculated_exp
    topic_exp.save
  end

  def update_partial_lesson_exp(partial: correctness, lesson_exp: s_l_e, question: q)
    return unless partial > 0 && partial < 0.99
    calculated_exp = calculate_exp(lesson_exp, question, partial)

    lesson_exp.exp += calculated_exp
    lesson_exp.save
  end

  def update_partial_topic_exp(partial: correctness, lesson_exp: s_l_e, topic_exp: s_t_e, question: q, topic_question: boolean=false)
    return unless partial > 0 && partial < 0.99
    calculated_exp = if topic_question
        calculate_topic_exp(topic_exp, question, partial)
      else
        calculate_exp(lesson_exp, question, partial)
      end

    topic_exp.exp += calculated_exp
    topic_exp.save
  end

  def calculate_exp(lesson_exp, question, correctness=1)
    streak_mtp = lesson_exp.streak_mtp
    calculated_exp = (question.experience * correctness * streak_mtp).to_i
    lesson_pass_exp = lesson_exp.lesson.pass_experience

    if lesson_pass_exp < lesson_exp.exp
      difference = lesson_exp.exp - calculated_exp
      return 0 if difference >= lesson_pass_exp
      calculated_exp = lesson_pass_exp - difference
    end
    calculated_exp
  end

  def calculate_topic_exp(topic_exp, question, correctness=1)
    reward_mtp = topic_exp.reward_mtp
    streak_mtp = topic_exp.streak_mtp
    (question.experience * correctness * streak_mtp * reward_mtp).to_i
  end

  def lesson_max_exp?(lesson_exp, topic_exp)
    lesson_exp.exp >= lesson_exp.lesson.pass_experience && (topic_exp.exp != 0)
  end

  def update_exp_streak_mtp(correct, experience, correctness)
    if correct
      experience.streak_mtp += 0.25
      experience.streak_mtp = 2 if experience.streak_mtp >= 2
    elsif correctness > 0
      experience.streak_mtp = (experience.streak_mtp - 1) * correctness + 1
    else
      experience.streak_mtp = 1
    end
    experience.save
  end


  def result_message(correct, correctness, question, experience, reward_mtp=1)
    question_exp = (question.experience * experience.streak_mtp).round.to_i

    if correct
      gained_exp = (question_exp * reward_mtp).round.to_i
      new_streak_bonus = (([experience.streak_mtp + 0.25, 2].min - 1) * 100).round.to_i
      "Correct! You have earnt #{gained_exp} experience points! " \
        "Your streak bonus is now #{new_streak_bonus} %!"
    elsif correctness > 0
      gained_exp = (question_exp * correctness * reward_mtp).round.to_i
      new_streak_bonus = ((experience.streak_mtp - 1) * correctness * 100).round.to_i
      "Partially correct! You have earnt #{gained_exp} / #{question_exp}" \
        " experience points! Your streak bonus is now reduced to #{new_streak_bonus} %."
    else
      'Incorrect, have a look at the solution and try another question!'
    end
  end

  def result_json(result, question, correct, params, current_user, topic, solution_image_url, correctness)
    {
      message: result,
      question_solution: question.solution,
      solution_image_url: solution_image_url,
      choice: correct,
      lesson_exp: (StudentLessonExp.current_exp(current_user, params[:lesson_id]) unless params[:lesson_id].blank?) ,
      topic_exp: StudentTopicExp.current_level_exp(current_user, topic),
      topic_next_level_exp: StudentTopicExp.next_level_exp(current_user, topic),
      topic_next_level: StudentTopicExp.current_level(current_user, topic) + 1,
      correctness: correctness
    }
  end

end
