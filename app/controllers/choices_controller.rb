class ChoicesController < ApplicationController

  def new
    @question = Question.find(params[:question_id])
    unit_id = @question.lesson.topic.unit.id
    if @question.maker == current_maker
      @choice = @question.choices.new
    else
      flash[:notice] = 'You can only add choices to your own questions'
      redirect_to "/units/#{unit_id}"
    end
  end

  def create
    @question = Question.find(params[:question_id])
    unit_id = @question.lesson.topic.unit.id
    @question.choices.create_with_maker(choice_params,current_maker)
    redirect_to "/units/#{unit_id}"
  end

  def choice_params
    params.require(:choice).permit!
  end

end
