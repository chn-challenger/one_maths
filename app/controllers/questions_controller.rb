class QuestionsController < ApplicationController
  include QuestionsHelper

  def select_lesson
    session[:select_lesson_id] = params[:lesson_id]
    if params[:order_group].nil? || params[:order_group] == ''
      session[:order_group] = 'all'
    else
      session[:order_group] = params[:order_group]
    end
    redirect_to "/questions"
  end

  def index
    if session[:select_lesson_id] == nil || session[:select_lesson_id] == ''
      @questions = []
    elsif session[:select_lesson_id] == 'all'
      @questions = Question.all
    elsif session[:select_lesson_id] == 'unused'
      @questions = Question.without_lessons
    else
      if session[:order_group] == 'all'
        @questions = Lesson.includes(:questions).find(session[:select_lesson_id]).questions
      else
        @questions = Lesson.includes(:questions).find(session[:select_lesson_id]).questions.where(order: session[:order_group])
      end
    end

    if session[:select_lesson_id] == nil || session[:select_lesson_id] == 0 || session[:select_lesson_id] == 'all'
      @questions.sort {|a,b| a.created_at <=> b.created_at}
    else
      @questions.sort {|a,b| a.order.to_s <=> b.order.to_s }
    end
  end

  def new
    unless can? :create, Question
      flash[:notice] = 'You do not have permission to create a question'
      redirect_to "/"
    else
      @referer = request.referer
      # if URI(@referer).path == "/" || URI(@referer).path == "/questions" || @referer.split("").last(11).join == "choices/new"
      #   @referer = "/questions/new"
      # end
      @questions = Question.all.order('updated_at').last(3).reverse
      @question = Question.new
    end
  end

  def create
    q = Question.create(question_params)
    if params[:question][:lesson_id]
      l = Lesson.find(params[:question][:lesson_id])
      l.questions << q
      l.save
    end
      redirect_to new_question_path
  end

  def show
  end

  def parser
    unless can? :create, Question
      flash[:notice] = "You do not have permission to create questions"
      redirect_to root_path
    else
      create_questions_from_tex(parser_params[:question_file].tempfile.path)
      flash[:notice] = "Questions have been saved successfully from the file"
      redirect_to new_question_path
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
    @question = Question.find(params[:id])
    if can? :edit, @question
      @question.update(question_params)
    else
      flash[:notice] = 'You do not have permission to edit a question'
    end
    redirect_back(fallback_location: new_question_path)
  end

  def destroy
    @question = Question.find(params[:id])
    if can? :delete, @question
      @question.destroy
      # referer = request.referer || "/questions/new"
      # redirect_to referer
      redirect_to new_question_path
    else
      flash[:notice] = 'You do not have permission to delete a question'
      redirect_to root_path
    end
  end

  def check_answer
    params_answers = standardise_param_answers(params)
    if current_user.student? || current_user.question_writer?
      question = Question.find(params[:question_id])

      correct = answer_result(params,params_answers)
      correctness = correctness(params,params_answers)

      record_answered_question(current_user,correct,params,params_answers)

      if params[:lesson_id]
        current_user.current_questions.where(question_id: params[:question_id])
          .last.destroy
        topic = Lesson.find(params[:lesson_id]).topic
        student_lesson_exp = get_student_lesson_exp(current_user,params)
        student_topic_exp = get_student_topic_exp(current_user,topic)

        result = result_message(correct,correctness,question,student_lesson_exp)

        update_exp(correct,student_lesson_exp,question,student_lesson_exp.streak_mtp)
        update_exp(correct,student_topic_exp,question,student_lesson_exp.streak_mtp)

        update_partial_exp(correctness,student_lesson_exp,question,student_lesson_exp.streak_mtp)
        update_partial_exp(correctness,student_topic_exp,question,student_lesson_exp.streak_mtp)

        update_exp_streak_mtp(correct,student_lesson_exp,correctness)
      elsif params[:topic_id]
        current_user.current_topic_questions.where(question_id: params[:question_id])
          .last.destroy
        topic = Topic.find(params[:topic_id])
        student_topic_exp = get_student_topic_exp(current_user,topic)

        result = result_message(correct,correctness,question,student_topic_exp)

        update_exp(correct,student_topic_exp,question,student_topic_exp.streak_mtp)
        update_partial_exp(correctness,student_topic_exp,question,student_topic_exp.streak_mtp)
        update_exp_streak_mtp(correct,student_topic_exp,correctness)
      end
    end
    # result = result_message(correct)

    if question.solution_image.exists?
      solution_image_url = question.solution_image.url(:medium).to_s
    else
      solution_image_url = nil
    end

    render json: result_json(result,question,correct,params,current_user,topic,solution_image_url,correctness)
  end

  def question_params
    params.require(:question).permit(:question_text, :solution, :difficulty_level, :experience, :order, :solution_image)
  end

  def answer_params
    params.require(:answers).permit!
  end

  private

  def parser_params
    params.require(:question).permit(:question_file)
  end

  def create_questions_from_tex(uploaded_tex_file)
    TexParser.new(uploaded_tex_file).convert
  end
end
