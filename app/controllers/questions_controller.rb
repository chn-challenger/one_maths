class QuestionsController < ApplicationController
  include QuestionsHelper
  include Tagable
  include QuestionSupport

  before_action :authenticate_user!

  def select_lesson
    session[:select_lesson_id] = params[:lesson_id]
    session[:order_group] = params[:order_group].blank? ? 'all' : params[:order_group]

    redirect_to '/questions'
  end

  def select_tags
    session[:select_tags] = params[:tags]
    redirect_back(fallback_location: questions_path)
  end

  def index
    if session[:select_lesson_id].blank?
      @questions = []
    elsif session[:select_lesson_id] == 'all'
      @questions = Question.all
    elsif session[:select_lesson_id] == 'unused'
      @questions = Question.without_lessons
    else
      if session[:order_group] == 'all'
        @questions = Lesson.joins(:questions).distinct.find(session[:select_lesson_id]).questions
      else
        @questions = Lesson.joins(:questions).distinct.find(session[:select_lesson_id]).questions.where(order: session[:order_group])
      end
    end

    if session[:select_lesson_id].nil? || session[:select_lesson_id] == 0 || session[:select_lesson_id] == 'all'
      @questions.sort_by(&:created_at)
    else
      @questions.sort { |a, b| a.order.to_s <=> b.order.to_s }
    end

    if session[:select_tags]
      if @questions.empty?
        return
      else
        @questions = @questions.select { |question| get_filtered_records(session[:select_tags], Question).include?(question) }
      end
    end
  end

  def new
    if can? :create, Question
      @referer = request.referer
      # if URI(@referer).path == "/" || URI(@referer).path == "/questions" || @referer.split("").last(11).join == "choices/new"
      #   @referer = "/questions/new"
      # end
      @questions = Question.all.order('updated_at').last(3).reverse
      @question = Question.new
    else
      flash[:notice] = 'You do not have permission to create a question'
      redirect_to '/'
    end
  end

  def create
    q = Question.new(question_params)
    if q.save!
      add_image(q, image_params[:question_image]) unless params[:question_image].blank?

      unless params[:question][:lesson_id].blank?
        append_to_lesson(q, params[:question][:lesson_id])
      end

      add_question_tags(q, params[:tags]) unless params[:tags].blank?
      flash[:notice] = "Successfully created a question."
    else
      flash[:alert] = "No question was saved please view console."
    end
    redirect_to new_question_path
  end

  def show
  end

  def parser
    if can? :create, Question
      create_questions_from_tex(parser_params[:question_file].tempfile.path)
      flash[:notice] = 'Questions have been saved successfully from the file'
      redirect_to new_question_path
    else
      flash[:notice] = 'You do not have permission to create questions'
      redirect_to root_path
    end
  end

  def edit
    @referer = request.referer
    @question = Question.find(params[:id])
    @job_example = get_example_question(params[:id])
    unless can? :edit, @question
      flash[:notice] = 'You do not have permission to edit a question'
      redirect_to root_path
    end
  end

  def update
    question = Question.find(params[:id])
    if can? :edit, question
      question.update(question_params)
      add_image(question, image_params[:question_image]) unless params[:question_image].blank?
      add_question_tags(question, params[:tags]) unless params[:tags].blank?
    else
      flash[:notice] = 'You do not have permission to edit a question'
    end
    redirect_back(fallback_location: new_question_path)
  end

  def delete_tag
    q = Question.find(params[:question_id])
    tag = Tag.find(params[:tag_id])

    if q.tags.delete(tag)
      flash[:notice] = 'Tag has been successfully deleted from this question.'
    else
      flash[:alert] = 'There was an error during tag deletion, please check the console.'
    end
    redirect_back(fallback_location: questions_path )
  end

  def destroy
    @question = Question.find(params[:id])
    if can? :delete, @question
      @question.destroy
      # referer = request.referer || "/questions/new"
      # redirect_to referer
      redirect_back(fallback_location: new_question_path)
    else
      flash[:notice] = 'You do not have permission to delete a question'
      redirect_to root_path
    end
  end

  def check_answer
    params_answers = standardise_param_answers(params)
    if current_user.student? || current_user.question_writer? || !session[:admin_view]
      question = Question.find(params[:question_id])

      correct = answer_result(params, params_answers)
      correctness = correctness(params, params_answers)
      lesson_streak_mtp = get_student_lesson_exp(current_user, params).streak_mtp

      record_answered_question(current_user, correct, params, params_answers, lesson_streak_mtp)

      if params[:lesson_id]
        current_user.current_questions.where(question_id: params[:question_id])
                    .last.destroy
        topic = Lesson.find(params[:lesson_id]).topic
        student_lesson_exp = get_student_lesson_exp(current_user, params)
        student_topic_exp = get_student_topic_exp(current_user, topic)

        result = result_message(correct, correctness, question, student_lesson_exp)

        update_exp(correct, student_lesson_exp, question, student_lesson_exp.streak_mtp)
        update_exp(correct, student_topic_exp, question, student_lesson_exp.streak_mtp)

        update_partial_exp(correctness, student_lesson_exp, question, student_lesson_exp.streak_mtp)
        update_partial_exp(correctness, student_topic_exp, question, student_lesson_exp.streak_mtp)

        update_exp_streak_mtp(correct, student_lesson_exp, correctness)
      elsif params[:topic_id]
        current_user.current_topic_questions.where(question_id: params[:question_id])
                    .last.destroy
                    
        topic = Topic.find(params[:topic_id])
        student_topic_exp = get_student_topic_exp(current_user, topic)

        result = result_message(correct, correctness, question, student_topic_exp)

        update_exp(correct, student_topic_exp, question, student_topic_exp.streak_mtp)
        update_partial_exp(correctness, student_topic_exp, question, student_topic_exp.streak_mtp)
        update_exp_streak_mtp(correct, student_topic_exp, correctness)
      end
    end
    # result = result_message(correct)

    if question.solution_image.exists?
      solution_image_url = question.solution_image.url(:medium).to_s
    else
      solution_image_url = nil
    end

    render json: result_json(result, question, correct,
                             params, current_user, topic,
                             solution_image_url, correctness)
  end

  private

  def question_params
    params.require(:question).permit(:question_text, :solution,
                                     :difficulty_level, :experience,
                                     :order, :solution_image)
  end

  def answer_params
    params.require(:answers).permit!
  end

  def image_params
    params.permit(:question_image)
  end

  def parser_params
    params.require(:question).permit(:question_file)
  end

  def create_questions_from_tex(uploaded_tex_file)
    TexParser.new(uploaded_tex_file).convert
  end
end
