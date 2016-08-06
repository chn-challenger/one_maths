class LessonsController < ApplicationController

  def new
    @topic = Topic.find(params[:topic_id])
    if @topic.maker == current_maker
      @lesson = @topic.lessons.new
    else
      flash[:notice] = 'You can only add lessons to your own topics'
      redirect_to "/"
    end
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @topic.lessons.create_with_maker(topic_params,current_maker)
    redirect_to "/"
  end

  # def show
  #   @topic = Topic.find(params[:id])
  # end
  #
  # def edit
  #   @topic = Topic.find(params[:id])
  #   if current_maker != @topic.maker
  #     flash[:notice] = 'You can only edit your own topics'
  #     redirect_to "/"
  #   end
  # end
  #
  # def update
  #   @topic = Topic.find(params[:id])
  #   @topic.update(topic_params)
  #   redirect_to '/'
  # end
  #
  # def destroy
  #   @topic = Topic.find(params[:id])
  #   if @topic.maker == current_maker
  #     @topic.destroy
  #   else
  #     flash[:notice] = 'Can only delete your own topics'
  #   end
  #   redirect_to '/'
  # end

  def topic_params
    params.require(:lesson).permit!
  end


end
