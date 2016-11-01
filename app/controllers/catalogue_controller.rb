class CatalogueController < ApplicationController
  include CatalogueHelper

  before_action :authenticate_user!

  def index
    image_collection = get_filtered_images(session[:tags])
    @catalogue = []
    image_collection.each do |image|
      record = [image, image.tags]
      @catalogue << record
    end
  end

  def image_filter
    if image_filter_params[:filter_tags] == ""
      flash[:notice] = 'You did not select any filter tags.'
    else
      session[:tags] = tag_sanitizer(image_filter_params[:filter_tags])
    end
    redirect_back(fallback_location: catalogue_path)
  end

  def create
    image = Image.new(name: image_params[:name], picture: image_params[:picture])
    tags = tag_sanitizer(image_params[:tags])
    if image.save!
      tags.each do |tag_name|
        tag = Tag.exists?(name: tag_name) ? Tag.find_by(name: tag_name) : Tag.create!(name: tag_name)
        image.tags << tag
      end
      flash[:notice] = 'Image successfully saved.'
      redirect_back(fallback_location: catalogue_path)
    else
      flash[:notice] = 'Error occured in saving the image please check the console.'
      redirect_back(fallback_location: catalogue_path)
    end
  end

  private

  def image_filter_params
    params.permit!
  end

  def image_params
    params.require(:image).permit(:name, :picture, :tags)
  end
end
