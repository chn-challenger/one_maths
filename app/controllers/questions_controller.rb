class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end

  def new
    if current_user
      @question = Question.new
    else
      flash[:notice] = 'You must be logged in as a user to add a lesson'
      redirect_to "/questions"
    end
  end

  def create
    current_user.questions.create(question_params)
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
    if current_user != @question.user
      flash[:notice] = 'You can only edit your own questions'
      redirect_to "/questions"
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update(question_params)
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
