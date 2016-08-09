class QuestionsController < ApplicationController

  def new
    @lesson = Lesson.find(params[:lesson_id])
    unit_id = @lesson.topic.unit.id
    if @lesson.maker == current_maker
      @question = @lesson.questions.new
    else
      flash[:notice] = 'You can only add questions to your own lessons'
      redirect_to "/units/#{unit_id}"
    end
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    unit_id = @lesson.topic.unit.id
    @lesson.questions.create_with_maker(question_params,current_maker)
    redirect_to "/units/#{unit_id}"
  end

  def show
    @question = Question.find(params[:id])
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
