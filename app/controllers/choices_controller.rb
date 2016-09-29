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
    question = Question.find(params[:question_id])
    params[:choices].each do |choice_param|
      unless choice_param[:content] == ""
        referer = choice_param[:redirect]
        question.choices.create(choice_params(choice_param))
      end
    end
    if params[:choices][0] == nil
      redirect = "/questions/new"
    else
      redirect = params[:choices][0][:redirect] || "/questions/new"
    end
    redirect_to redirect
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
    redirect = params[:choice][:redirect] || "/questions/new"
    redirect_to redirect
  end

  def destroy
    @choice = Choice.find(params[:id])
    if can? :delete, @choice
      @choice.destroy
    else
      flash[:notice] = 'You do not have permission to delete a choice'
    end
    referer = request.referer
    redirect_to referer
  end

  def attach_image
    @choice = Choice.find(params[:id])
    unless can? :create, Image
      flash[:notice] = 'You do not have permission to create an image'
      redirect_to "/"
    else
      @image = Image.new
    end
  end

  def create_image
    Image.create(image_params)
    redirect_to "/images"
  end

  def choice_params(single_param)
    single_param.permit(:content, :correct)
  end

  def single_choice_params
    params.require(:choice).permit(:content, :correct)
  end

  def image_params
    params.require(:image).permit(:name,:picture)
  end

end
