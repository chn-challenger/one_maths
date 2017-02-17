class CheckAnswerService
  include InputProcessorSupport
  attr_reader :question, :correct, :correctness, :answer_params, :params

  def initialize(params:,user:)
    @params = params.dup.symbolize_keys!
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

  def update_user_experience
    service_options = { correctness: correctness, question: question,
                        topic_question: topic_question? }.merge(load_student_exp)

    UpdateStudentExpService.new(service_options)
  end

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
    else
      choice_id = params[:choice]
      correctness = 1 if Choice.find(choice_id).correct
    end
    correctness
  end

  def record_answered_question
    answer_type_options = topic_question? ? extract_lesson : extract_topic
    streak_mtp = fetch_student_exp(record_hash: answer_type_options).streak_mtp

    options = { user_id: @user.id, question_id: @question.id,
                correct: @correct, answer: @answer_params,
                streak_mtp: streak_mtp, correctness: @correctness,
              }
    answered_question_params = options.merge(answer_type_options)

    AnsweredQuestion.create(answered_question_params)
  end

  def standardise_answer_params
    return {} if params[:js_answers].blank?
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

  def fetch_student_exp(record_hash: nil, record: nil)
    if record_hash.blank?
      record_class = record.class
      query_options = {user: @user, record.class.to_s.downcase => record }
    else
      record_class = record_hash.keys[0][/([^_]+)/i].capitalize
      query_options = {user: @user}.merge(record_hash)
    end

    new_record_opts = query_options.merge({
                        exp: 0, streak_mtp: 1
                      })
    exp_class = "Student#{record_class}Exp".constantize
    exp_class.where(query_options).first_or_create(new_record_opts)
  end

  def load_student_exp
    unless topic_question?
      lesson_exp = fetch_student_exp(record_hash: extract_lesson, record: nil)
      topic = lesson_exp.lesson.topic
    end

    topic_exp = fetch_student_exp(record_hash: extract_topic, record: topic)

    { topic_exp: topic_exp, lesson_exp: lesson_exp }
  end

  def extract_lesson
    params.select { |k, v| :lesson_id == k }
  end

  def extract_topic
    params.select { |k, v| :topic_id == k }
  end

  def topic_question?
    params[:topic_id].present?
  end
end
