class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    # Question.create_with_maker(question_params,current_maker)
    current_maker.questions.create(question_params)
    redirect_to "/"
  end

  def show
    @question = Question.find(params[:id])
    render json: {question_solution: @question.solution}
    # render json: {question: @question}
  end

  def edit
    @question = Question.find(params[:id])
    unit_id = @question.lesson.topic.unit.id
    if current_maker != @question.maker
      flash[:notice] = 'You can only edit your own questions'
      redirect_to "/units/#{unit_id}"
    end
  end

  def update
    @question = Question.find(params[:id])
    unit_id = @question.lesson.topic.unit.id
    @question.update(question_params)
    redirect_to "/units/#{unit_id}"
  end

  def destroy
    @question = Question.find(params[:id])
    unit_id = @question.lesson.topic.unit.id
    if @question.maker == current_maker
      @question.destroy
    else
      flash[:notice] = 'Can only delete your own questions'
    end
    redirect_to "/units/#{unit_id}"
  end

  def question_params
    params.require(:question).permit!
  end

end
