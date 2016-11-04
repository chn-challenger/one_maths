class CatalogueController < ApplicationController
  include CatalogueHelper

  before_action :authenticate_user!
  load_and_authorize_resource :image, :parent => false

  def new
    @last_image = Image.last
  end

  def exam_questions
    image_collection = get_filtered_images(session[:tags])
    @show_tags = !!session[:show_tags]
    @show_crud = !!session[:show_crud]
    @catalogue = []
    image_collection.each do |image|
      record = [image, image.tags]
      @catalogue << record
    end
  end

  def image_filter
    if params[:filter_tags] == ""
      flash[:notice] = 'You did not select any filter tags.'
    else
      session[:tags] = tag_sanitizer(params[:filter_tags])
      session[:show_tags] = params[:show_tags]
      session[:show_crud] = params[:show_crud]
    end
    redirect_back(fallback_location: exam_questions_path)
  end

  def create
    if image_params[:image_url] != ""
      image = Image.new(name: image_params[:name], picture: URI.parse(image_params[:image_url]))
    else
      image = Image.new(name: image_params[:name], picture: image_params[:picture])
    end

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

  def edit
    @exam_question = Image.find(params[:id])
  end

  def delete_tag
    image = Image.find(params[:image_id])
    tag = Tag.find(params[:tag_id])
    if image.tags.delete(tag)
      flash[:notice] = 'Tag has been successfully deleted from this question.'
    else
      flash[:alert] = 'There was an error during tag deletion, please check the console.'
    end
    redirect_back(fallback_location: exam_questions_path )
  end

  def update_tags
    image = Image.find(update_tags_params[:image_id])
    tags = tag_sanitizer(update_tags_params[:tags])

    if !!image && !!tags
      tags.each do |tag_name|
        next if !!image.tags.where(name: tag_name).first
        tag = Tag.exists?(name: tag_name) ? Tag.find_by(name: tag_name) : Tag.create!(name: tag_name)
        image.tags << tag
      end
      flash[:notice] = 'Tag successfully added to exam question.'
      redirect_back(fallback_location: exam_questions_path)
    else
      flash[:alert] = 'Tag was NOT added to exam question, please check the console.'
      redirect_back(fallback_location: exam_questions_path)
    end
  end

  private

  def image_filter_params
    params.permit!
  end

  def image_params
    params.require(:image).permit(:name, :picture, :tags, :image_url)
  end

  def update_tags_params
    params.require(:tag).permit(:tags, :image_id)
  end
end
