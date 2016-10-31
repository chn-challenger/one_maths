class CatalogueController < ApplicationController
  include CatalogueHelper

  before_action :authenticate_user!

  def index
    @images = get_images_with_tags
  end

  def image_filter
    image_collection = get_filtered_images(image_filter_params[:tags])
    @records = []
    image_collection.each do |image|
      record = [image, image.tags]
      @records << record
    end
  end

  def create

  end

  private

  def image_filter_params
    params[:tags] ||= []
    params.permit(tags: [])
  end

  def image_params
    params[:image][:tags] ||= []
    params.require(:image).permit(:name, :picture, :tags)
  end
end
