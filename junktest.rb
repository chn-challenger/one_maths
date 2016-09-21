def check_topic_answer
  if current_user and current_user.student?
    AnsweredQuestion.create(user_id: current_user.id, question_id:
      params[:question_id], correct: params[:choice])

    current_user.current_topic_questions.where(question_id: params[:question_id])
      .last.destroy

    question = Question.find(params[:question_id])

    topic = Topic.find(params[:topic_id])
    student_topic_exp = StudentTopicExp.where(user_id: current_user.id, topic_id: topic.id ).first ||
      StudentTopicExp.create(user_id: current_user.id, topic_id: topic.id, topic_exp: 0, streak_mtp: 1)
  end
  choice = Choice.find(params[:choice]).correct
  if choice
    result = "Correct answer! Well done!"
    student_topic_exp.topic_exp += (question.experience * student_topic_exp.streak_mtp)
    student_topic_exp.streak_mtp *= 1.2
    if student_topic_exp.streak_mtp > 2
      student_topic_exp.streak_mtp = 2
    end
    student_topic_exp.save
  else
    result = "Incorrect, have a look at the solution and try another question!"
    student_topic_exp.streak_mtp = 1
    student_topic_exp.save
  end

  render json: {
    message: result,
    question_solution: question.solution,
    choice: choice,
    topic_exp: StudentTopicExp.current_level_exp(current_user,topic),
    topic_next_level_exp: StudentTopicExp.next_level_exp(current_user,topic),
    topic_next_level: StudentTopicExp.current_level(current_user,topic) + 1
  }
end



def check_answer
  params_answers = {}
  if !!params[:js_answers]
    params[:js_answers].each do |index,array|
      params_answers[array[0]] = array[1]
    end
  else
    params_answers = params[:answers]
  end

  if current_user and current_user.student?

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
        correct = false if question_answers[label] != answer
      end
    end

    AnsweredQuestion.create(user_id:current_user.id,question_id:
      question.id,correct:correct)

    current_user.current_questions.where(question_id: params[:question_id])
      .last.destroy

    student_lesson_exp = StudentLessonExp.where(user_id: current_user.id, lesson_id: params[:lesson_id]).first ||
      StudentLessonExp.create(user_id: current_user.id, lesson_id: params[:lesson_id], lesson_exp: 0, streak_mtp: 1)

    topic = Lesson.find(params[:lesson_id]).topic
    student_topic_exp = StudentTopicExp.where(user_id: current_user.id, topic_id: topic.id ).first ||
      StudentTopicExp.create(user_id: current_user.id, topic_id: topic.id, topic_exp: 0, streak_mtp: 1)
  end

  if correct
    result = "Correct answer! Well done!"
    student_lesson_exp.lesson_exp += (question.experience * student_lesson_exp.streak_mtp)
    student_topic_exp.topic_exp += (question.experience * student_lesson_exp.streak_mtp)
    student_lesson_exp.streak_mtp *= 1.2
    if student_lesson_exp.streak_mtp > 2
      student_lesson_exp.streak_mtp = 2
    end
    student_lesson_exp.save
    student_topic_exp.save
  else
    result = "Incorrect, have a look at the solution and try another question!"
    student_lesson_exp.streak_mtp = 1
    student_lesson_exp.save
  end
  render json: {
    message: result,
    question_solution: question.solution,
    choice: correct,
    lesson_exp: StudentLessonExp.current_exp(current_user,params[:lesson_id]),
    topic_exp: StudentTopicExp.current_level_exp(current_user,topic),
    topic_next_level_exp: StudentTopicExp.next_level_exp(current_user,topic),
    topic_next_level: StudentTopicExp.current_level(current_user,topic) + 1
  }
end











let!(:question_16){create_question_with_order(16,"c1")}
let!(:answer_16){create_answer(question_16,16)}
let!(:question_15){create_question_with_order(15,"e1")}
let!(:answer_15){create_answer(question_15,15)}
let!(:question_12){create_question_with_order(12,"z1")}
let!(:answer_12){create_answer(question_12,12)}
let!(:question_11){create_question_with_order(11,"d1")}
let!(:answer_11){create_answer(question_11,11)}
let!(:question_14){create_question_with_order(14,"d1")}
let!(:answer_14){create_answer(question_14,14)}
let!(:question_13){create_question_with_order(13,"b1")}
let!(:answer_13){create_answer(question_13,13)}

let!(:question_21){create_question_with_order(21,"c1")}
let!(:answer_21){create_answer(question_21,21)}
let!(:question_22){create_question_with_order(22,"e1")}
let!(:answer_22){create_answer(question_22,22)}
let!(:question_23){create_question_with_order(23,"e1")}
let!(:answer_23){create_answer(question_23,23)}
let!(:question_24){create_question_with_order(24,"d1")}
let!(:answer_24){create_answer(question_24,24)}
let!(:question_25){create_question_with_order(25,"b1")}
let!(:answer_25){create_answer(question_25,25)}
let!(:question_26){create_question_with_order(26,"z1")}
let!(:answer_26){create_answer(question_26,26)}
