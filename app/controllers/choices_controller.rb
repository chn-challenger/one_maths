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
    choice = @question.choices.create_with_maker(choice_params,current_maker)
    redirect_to "/units/#{unit_id}"
  end

  def edit
    @choice = Choice.find(params[:id])
    if current_maker != @choice.maker
      unit_id = @choice.question.lesson.topic.unit.id
      flash[:notice] = 'You can only edit your own choices'
      redirect_to "/units/#{unit_id}"
    end
  end

  def update
    @choice = Choice.find(params[:id])
    unit_id = @choice.question.lesson.topic.unit.id
    @choice.update(choice_params)
    redirect_to "/units/#{unit_id}"
  end

  def destroy
    @choice = Choice.find(params[:id])
    unit_id = @choice.question.lesson.topic.unit.id
    if @choice.maker == current_maker
      @choice.destroy
    else
      flash[:notice] = 'Can only delete your own choices'
    end
    redirect_to "/units/#{unit_id}"
  end

  def choice_params
    params.require(:choice).permit!
  end

end
