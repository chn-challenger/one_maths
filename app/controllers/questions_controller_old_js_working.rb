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
    # p question_params
    answer = params[:choice] == 'true' ? :correct : :incorrect
    @question = Question.find(params[:id])
    if current_user and current_user.student?
      u_id = current_user.id
      q_id = @question.id

      correct = params[:choice]
      # @answered_question = AnsweredQuestion.create(user_id: u_id, question_id: q_id, correct: correct)
      AnsweredQuestion.create(user_id: u_id, question_id: q_id, correct: correct)

      # current_user.current_questions.where("question_id=?",q_id).destroy
      # puts "=============== LINE 1=============="
      # p @question
      # puts q_id
      # p current_user.current_questions
      # puts "=============== LINE 2 =============="
    end
    render json: {
      message: answer,
      question_solution: @question.solution
    }
    # visit '/'
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
    # params.require(:lesson_id).permit!
  end
end
