class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    unless can? :create, @question
      flash[:notice] = 'You do not have permission to create a question'
      redirect_to "/questions"
    end
  end

  def create
    Question.create(question_params)
    redirect_to "/questions"
  end

  def show
  end

  def check_answer
    puts params[:choice]
    if params[:choice] == 'true'
      answer = :correct
    else
      answer = :incorrect
    end
    @question = Question.find(params[:id])
    render json: {
      message: answer,
      question_solution: @question.solution
    }
  end

  def edit
    @question = Question.find(params[:id])
    unless can? :edit, @question
      flash[:notice] = 'You do not have permission to edit a question'
      redirect_to "/questions"
    end
  end

  def update
    @question = Question.find(params[:id])
    if can? :edit, @question
      @question.update(question_params)
    else
      flash[:notice] = 'You do not have permission to edit a question'
    end
    redirect_to "/questions"
  end

  def destroy
    @question = Question.find(params[:id])
    if @question.user == current_user
      @question.destroy
    else
      flash[:notice] = 'Can only delete your own questions'
    end
    redirect_to "/questions"
  end

  def question_params
    params.require(:question).permit!
  end

end
