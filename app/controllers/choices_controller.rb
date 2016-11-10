class ChoicesController < ApplicationController
  include AnswersChoicesHelper

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
      @choice.images.each do |image|
        image.destroy
      end
      @choice.destroy
    else
      flash[:notice] = 'You do not have permission to delete a choice'
    end
    redirect = request.referer
    redirect_to redirect
  end

  def attach_image
    @referer = request.referer
    @choice = Choice.find(params[:id])
    unless can? :create, Image
      flash[:notice] = 'You do not have permission to create an image'
      redirect_to "/"
    else
      @image = Image.new
    end
  end

  def create_image
    image = Image.create(image_params)
    choice = Choice.find(params[:id])
    choice.images << image
    choice.save
    # redirect_to "/questions/new"
    redirect = params[:image][:redirect] || "/questions/new"
    redirect_to redirect
  end

  def choice_params(single_param)
    single_param[:correct] ||= false
    single_param.permit(:content, :correct)
  end

  def single_choice_params
    params.require(:choice).permit(:content, :correct)
  end

  def image_params
    params.require(:image).permit(:name,:picture)
  end

end
