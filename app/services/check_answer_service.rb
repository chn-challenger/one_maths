class CheckAnswerService
  include InputProcessorSupport

  def initialize(params:,user:)
    @params = params.dup
    @user = user
    @answer_params = nil
    @question = nil
    @correct = false
    @correctness = 0
  end

  def check_answer
    set_answer_params
    set_question
    set_correct_and_correctness
  end

  private

  attr_reader :params, :question

  def set_question
    @question = Question.includes(:answers, :choices).find(params[:question_id])
  end

  def set_answer_params
    @answer_params = standardise_answer_params
  end

  def set_correct_and_correctness
    @correct = correct?
    @correctness = correctness
  end

  def correct?
    choice_id = params[:choice]
    if choice_id.present?
      correct = Choice.find(choice_id).correct
    else
      correct = true if correctness == 1
    end
  end

  def correctness
    correctness = 0
    unless params[:choice].present?
      question_answers = question.answers_hash

      single_answer_value = 1.0 / question_answers.length

      question_answers.each do |label, answer|
        answer_type = answer[:answer_type]
        question_answer = answer[:solution]
        student_answer = @answer_params[label]
        correctness += single_answer_value * standardise_answer(ans_type, q_ans, student_answer)
      end
    end
    correctness
  end

  def record_answered_question
    answer_type_options = params[:topic_id].blank? ? {lesson_id: params[:lesson_id]} : {topic_id: params[:topic_id]}
    streak_mtp = fetch_student_exp(record_hash: answer_type_options).streak_mtp

    options = { user_id: @user.id, question_id: @question.id,
                correct: @correct, answer: @answer_params,
                streak_mtp: streak_mtp, correctness: @correctness,
              }
    answered_question_params = options.merge(answer_type_options)

    AnsweredQuestion.create(answered_question_params)
  end

  def standardise_answer_params
    answer_params = {}

    unless params.blank?
      params[:js_answers].each do |_index, array|
        answer_params[array[0]] = array[1]
      end
    else
      answer_params = params[:answers]
    end
    answer_params
  end

  def fetch_student_exp(record_hash:)
    record_class = record_hash.keys[0][/([^_]+)/i].capitalize
    exp_class = "Student#{record_class}Exp".constantize
    query_options = {user: @user}.merge(record_hash)
    exp_class.where(query_options).first
  end
end
