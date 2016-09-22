class AnswersController < ApplicationController

  def new
    @referer = request.referer
    @question = Question.find(params[:question_id])
    if can? :create, Answer
      @answers = []
      5.times{@answers << @question.answers.new}
    else
      flash[:notice] = 'You do not have permission to create an answer'
      redirect_to "/questions"
    end
  end

  def create
    question = Question.find(params[:question_id])
    params[:answers].each do |answer_param|
      unless answer_param[:label] == ""
        referer = answer_param[:redirect]
        question.answers.create(answer_params(answer_param))
      end
    end
    # referer = "/questions/new"
    # redirect_to referer
    if params[:answers][0] == nil
      redirect = "/questions/new"
    else
      redirect = params[:answers][0][:redirect] || "/questions/new"
    end
    redirect_to redirect
  end

  def edit
    @referer = request.referer
    @answer = Answer.find(params[:id])
    unless can? :edit, @answer
      flash[:notice] = 'You do not have permission to edit an answer'
      redirect_to "/"
    end
  end

  def update
    answer = Answer.find(params[:id])
    answer.update(single_answer_params)
    # redirect_to params[:answer][:redirect]
    redirect = params[:answer][:redirect] || "/questions/new"
    redirect_to redirect
  end

  def destroy
    if can? :delete, Answer
      Answer.find(params[:id]).destroy
      referer = request.referer
      redirect_to referer
    else
      flash[:notice] = 'You do not have permission to delete an answer'
      redirect_to '/'
    end

  end

  def answer_params(single_param)
    single_param.permit(:label, :solution, :hint)
  end

  def single_answer_params
    params.require(:answer).permit(:label, :solution, :hint)
  end

end
