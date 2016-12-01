class TagsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    def index
      @tags = Tag.all
    end

    def new
      @tag = Tag.new
    end

    def edit
      @tag = Tag.find(params[:id])
    end

    def create
      tag = Tag.new(tag_params)
      if tag.save!
        flash[:notice] = 'Tag has been successfully saved.'
      else
        flash[:alert] = 'There was an error during tag saving, please check the console.'
      end
      redirect_to tags_path
    end

    def destroy
      tag = Tag.find(params[:id])
      if tag.destroy!
        flash[:notice] = "Tag #{tag.name} has been successfully deleted."
      else
        flash[:alert] = 'There was an error during tag deletion, please check the console.'
      end
      redirect_back(fallback_location: tags_path)
    end

    def update
      tag = Tag.find(params[:id])
      tag.update(tag_params)
      redirect_to tags_path
    end

    private

    def tag_params
      params.require(:tag).permit(:name)
    end
end
