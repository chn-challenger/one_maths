class CatalogueController < ApplicationController
  include Tagable
  include CatalogueSupport

  before_action :authenticate_user!

  def new
    @last_image = Image.joins(:tags).last
  end

  def exam_questions
    image_collection = get_filtered_records(session[:tags], Image)
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
      session[:tags] = params[:filter_tags]
      session[:show_tags] = params[:show_tags]
      session[:show_crud] = params[:show_crud]
    end
    redirect_back(fallback_location: exam_questions_path)
  end

  def create
    image = new_image(image_params)
    tag_names = tag_sanitizer(image_params[:tags])

    if image.save!
      add_tags(image, tag_names)
      flash[:notice] = 'Image successfully saved.'
    else
      flash[:notice] = 'Error occured in saving the image please check the console.'
    end
    redirect_back(fallback_location: catalogue_path)
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
    set = tags_setter(update_tags_params)

    if set
      flash[:notice] = 'Tag successfully added to exam question.'
    else
      flash[:alert] = 'Tag was NOT added to exam question, please check the console.'
    end
    redirect_back(fallback_location: exam_questions_path)
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
