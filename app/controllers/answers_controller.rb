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
    referer = "/questions/new"
    question = Question.find(params[:question_id])
    params[:answers].each do |answer_param|
      unless answer_param[:label] == ""
        referer = answer_param[:redirect]
        question.answers.create(answer_params(answer_param))
      end
    end
    redirect_to referer
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
    redirect_to params[:answer][:redirect]
  end

  def destroy
    referer = request.referer
    if can? :delete, Answer
      Answer.find(params[:id]).destroy
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
