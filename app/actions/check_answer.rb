class CheckAnswer
  include InputProcessorSupport

  def initialize(params)
    @params = params
    @answer_params = nil
    @question = nil
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

  def set_correct
    choice_id = params[:choice]
    if !choice_id.blank?
      @correct = Choice.find(choice_id).correct
    else
      question_answers = question.answers_hash
      @correct = true
      question_answers.each do |label, answer|
        answer_type = answer[:answer_type]
        question_answer = answer[:solution]
        student_answer = @answer_params[label]
        @correct = false unless standardise_answer(answer_type, question_answer, student_answer)
      end
    end
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

end
