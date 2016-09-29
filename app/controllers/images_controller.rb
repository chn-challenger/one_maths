class ImagesController < ApplicationController

  def index
    @images = Image.all
  end

  def new
    unless can? :create, Image
      flash[:notice] = 'You do not have permission to create an image'
      redirect_to "/"
    else
      # @referer = request.referer
      @image = Image.new
    end
  end

  def create
    Image.create(image_params)
    redirect_to "/images"
  end

  def edit
    @image = Image.find(params[:id])
    unless can? :edit, Image
      flash[:notice] = 'You do not have permission to edit an image'
      redirect_to "/"
    end
  end

  def update
    @image = Image.find(params[:id])
    @image.update(image_params)
    redirect_to '/images'
  end

  def destroy
    @image = Image.find(params[:id])
    if can? :delete, Image
      @image.destroy
    end
    redirect_to '/images'
  end

  def image_params
    params.require(:image).permit(:name,:picture)
  end


end
