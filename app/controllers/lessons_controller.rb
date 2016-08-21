class LessonsController < ApplicationController

  def new
    @topic = Topic.find(params[:topic_id])
    if can? :create, Lesson
      @lesson = @topic.lessons.new
    else
      flash[:notice] = 'You do not have permission to add a lesson'
      redirect_to "/units/#{ @topic.unit.id }"
    end
  end

  def create
    topic = Topic.find(params[:topic_id])
    topic.lessons.create(lesson_params)
    redirect_to "/units/#{ topic.unit.id }"
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  def edit
    @lesson = Lesson.find(params[:id])
    unless can? :edit, @lesson
      flash[:notice] = 'You do not have permission to edit a lesson'
      redirect_to "/units/#{ @lesson.topic.unit.id }"
    end
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson.update(lesson_params)
    redirect_to "/units/#{ @lesson.topic.unit.id }"
  end

  def destroy
    lesson = Lesson.find(params[:id])
    if can? :delete, lesson
      lesson.destroy
      flash[:notice] = 'Lesson deleted successfully'
    else
      flash[:notice] = 'You do not have permission to delete a lesson'
    end
    redirect_to "/units/#{ lesson.topic.unit.id }"
  end

  def lesson_params
    params.require(:lesson).permit!
  end
end
