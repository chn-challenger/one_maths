class ChoicesController < ApplicationController

  def new
    @question = Question.find(params[:question_id])
    if can? :create, Choice
      @choice = @question.choices.new
    else
      flash[:notice] = 'You do not have permission to create a choice'
      redirect_to "/questions"
    end
  end

  def create
    question = Question.find(params[:question_id])
    question.choices.create(choice_params)
    redirect_to "/questions"
  end

  def edit
    @choice = Choice.find(params[:id])
    unless can? :edit, @choice
      flash[:notice] = 'You do not have permission to edit a choice'
      redirect_to "/questions"
    end
  end

  def update
    choice = Choice.find(params[:id])
    choice.update(choice_params)
    redirect_to "/questions"
  end

  def destroy
    @choice = Choice.find(params[:id])
    if can? :delete, @choice
      @choice.destroy
    else
      flash[:notice] = 'You do not have permission to delete a choice'
    end
    redirect_to "/questions"
  end

  def choice_params
    params.require(:choice).permit!
  end

end
