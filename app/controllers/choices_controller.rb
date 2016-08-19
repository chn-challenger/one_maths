class ChoicesController < ApplicationController

  def new
    @question = Question.find(params[:question_id])
    if @question.user == current_user
      @choice = @question.choices.new
    else
      flash[:notice] = 'You can only add choices to your own questions'
      redirect_to "/questions"
    end
  end

  def create
    @question = Question.find(params[:question_id])
    choice = @question.choices.create_with_user(choice_params,current_user)
    redirect_to "/questions"
  end

  def edit
    @choice = Choice.find(params[:id])
    if current_user != @choice.user
      flash[:notice] = 'You can only edit your own choices'
      redirect_to "/questions"
    end
  end

  def update
    @choice = Choice.find(params[:id])
    @choice.update(choice_params)
    redirect_to "/questions"
  end

  def destroy
    @choice = Choice.find(params[:id])
    if @choice.user == current_user
      @choice.destroy
    else
      flash[:notice] = 'Can only delete your own choices'
    end
    redirect_to "/questions"
  end

  def choice_params
    params.require(:choice).permit!
  end

end
