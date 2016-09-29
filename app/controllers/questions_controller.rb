class QuestionsController < ApplicationController
  include QuestionsHelper

  def select_lesson
    session[:select_lesson_id] = params[:lesson_id]
    redirect_to "/questions"
  end

  def index
    if session[:select_lesson_id] == nil || session[:select_lesson_id] == ''
      @questions = []
    elsif session[:select_lesson_id] == 'all'
      @questions = Question.all.to_a
    elsif session[:select_lesson_id] == 'unused'
      @questions = Question.all.select {|q| q.lessons.length == 0}
    else
      @questions = Question.all.select {|q| !!q.lessons.first && session[:select_lesson_id].to_i == q.lessons.first.id}
    end

    if session[:select_lesson_id] == nil || session[:select_lesson_id] == 0 || session[:select_lesson_id] == 'all'
      @questions.sort! {|a,b| a.created_at <=> b.created_at}
    else
      @questions.sort! {|a,b| a.order <=> b.order}
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
      redirect_to "/questions/new"
      # redirect = params[:question][:redirect] || "/questions/new"
      # redirect_to redirect
  end

  def show
  end

  def edit
    @referer = request.referer
    @question = Question.find(params[:id])
    unless can? :edit, @question
      flash[:notice] = 'You do not have permission to edit a question'
      redirect_to "/"
    end
  end

  def update
    @question = Question.find(params[:id])
    if can? :edit, @question
      @question.update(question_params)
    else
      flash[:notice] = 'You do not have permission to edit a question'
    end
    redirect = params[:question][:redirect] || "/questions/new"
    redirect_to redirect
    # redirect_to "/questions/new"
  end

  def destroy
    @question = Question.find(params[:id])
    if can? :delete, @question
      @question.destroy
      # referer = request.referer || "/questions/new"
      # redirect_to referer
      redirect_to "/questions/new"
    else
      flash[:notice] = 'You do not have permission to delete a question'
      redirect_to "/"
    end
  end

  def check_answer
    params_answers = standardise_param_answers(params)
    if current_user and current_user.student?
      question = Question.find(params[:question_id])
      correct = answer_result(params,params_answers)
      record_answered_question(current_user,correct,params)
      if params[:lesson_id]
        current_user.current_questions.where(question_id: params[:question_id])
          .last.destroy
        topic = Lesson.find(params[:lesson_id]).topic
        student_lesson_exp = get_student_lesson_exp(current_user,params)
        student_topic_exp = get_student_topic_exp(current_user,topic)
        update_exp(correct,student_lesson_exp,question,student_lesson_exp.streak_mtp)
        update_exp(correct,student_topic_exp,question,student_lesson_exp.streak_mtp)
        update_exp_streak_mtp(correct,student_lesson_exp)
      elsif params[:topic_id]
        current_user.current_topic_questions.where(question_id: params[:question_id])
          .last.destroy
        topic = Topic.find(params[:topic_id])
        student_topic_exp = get_student_topic_exp(current_user,topic)
        update_exp(correct,student_topic_exp,question,student_topic_exp.streak_mtp)
        update_exp_streak_mtp(correct,student_topic_exp)
      end
    end
    result = result_message(correct)

    if question.solution_image.exists?
      solution_image_url = question.solution_image.url(:medium).to_s
    else
      solution_image_url = nil
    end

    render json: result_json(result,question,correct,params,current_user,topic,solution_image_url)
  end

  def question_params
    params.require(:question).permit(:question_text, :solution, :difficulty_level, :experience, :order, :solution_image)
  end

  def answer_params
    params.require(:answers).permit!
  end
end
