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

end
