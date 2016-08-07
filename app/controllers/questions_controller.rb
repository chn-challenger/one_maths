class QuestionsController < ApplicationController

  def new
    @lesson = Lesson.find(params[:lesson_id])
    if @lesson.maker == current_maker
      @question = @lesson.questions.new
    else
      flash[:notice] = 'You can only add questions to your own lessons'
      redirect_to "/"
    end
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @lesson.questions.create_with_maker(question_params,current_maker)
    redirect_to "/"
  end

  def question_params
    params.require(:question).permit!
  end

end
