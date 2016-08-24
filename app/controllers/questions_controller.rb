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
    if current_user and current_user.student?
      AnsweredQuestion.create(user_id: current_user.id, question_id:
        params[:question_id], correct: params[:choice])
      current_user.current_questions.where("question_id=?",params[:question_id])
        .last.destroy
    end
    render json:{message: params[:choice],question_solution:
      Question.find(params[:question_id]).solution}
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
    if can? :delete, @question
      @question.destroy
    else
      flash[:notice] = 'You do not have permission to delete a question'
    end
    redirect_to "/questions"
  end

  def question_params
    params.require(:question).permit!
  end
end
