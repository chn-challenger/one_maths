class ChoicesController < ApplicationController

  def new
    @referer = request.referer
    @question = Question.find(params[:question_id])
    if can? :create, Choice
      @choices = []
      5.times{@choices << @question.choices.new}
    else
      flash[:notice] = 'You do not have permission to create a choice'
      redirect_to "/questions"
    end
  end

  def create
    referer = "/questions/new"
    question = Question.find(params[:question_id])
    params[:choices].each do |choice_param|
      unless choice_param[:content] == ""
        referer = choice_param[:redirect]
        question.choices.create(choice_params(choice_param))
      end
    end
    redirect_to referer
  end

  def edit
    @referer = request.referer
    @choice = Choice.find(params[:id])
    unless can? :edit, @choice
      flash[:notice] = 'You do not have permission to edit a choice'
      redirect_to "/questions"
    end
  end

  def update
    choice = Choice.find(params[:id])
    choice.update(single_choice_params)
    redirect_to params[:choice][:redirect]
  end

  def destroy
    referer = request.referer
    @choice = Choice.find(params[:id])
    if can? :delete, @choice
      @choice.destroy
    else
      flash[:notice] = 'You do not have permission to delete a choice'
    end
    redirect_to referer
  end

  def choice_params(single_param)
    single_param.permit(:content, :correct)
  end

  def single_choice_params
    params.require(:choice).permit(:content, :correct)
  end

end
