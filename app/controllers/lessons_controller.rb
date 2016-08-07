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
    @topic.lessons.create_with_maker(lesson_params,current_maker)
    redirect_to "/"
  end


  def show
    @lesson = Lesson.find(params[:id])
  end

  def edit
    @lesson = Lesson.find(params[:id])
    if current_maker != @lesson.maker
      flash[:notice] = 'You can only edit your own lessons'
      redirect_to "/"
    end
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson.update(lesson_params)
    redirect_to '/'
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    if @lesson.maker == current_maker
      @lesson.destroy
    else
      flash[:notice] = 'Can only delete your own lessons'
    end
    redirect_to '/'
  end

  def lesson_params
    params.require(:lesson).permit!
  end


end
