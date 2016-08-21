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

  def new_question
    @lesson = Lesson.find(params[:id])
    @questions = Question.all
    unless can? :edit, @lesson
      flash[:notice] = 'You do not have permission to add questions to lesson'
      redirect_to "/units/#{ @lesson.topic.unit.id }"
    end
  end

  def create_question
    lesson = Lesson.find(params[:id])
    if can? :edit, lesson
      lesson.questions = Question.where(id: params[:question_ids])
      lesson.save
    else
      flash[:notice] = 'You do not have permission to create questions to lesson'
    end
    redirect_to "/units/#{lesson.topic.unit.id}"
  end

  def lesson_params
    params.require(:lesson).permit!
  end
end

# class LessonsController < ApplicationController
#
#   def new
#     @topic = Topic.find(params[:topic_id])
#     unit_id = @topic.unit.id
#     if @topic.user == current_user
#       @lesson = @topic.lessons.new
#     else
#       flash[:notice] = 'You can only add lessons to your own topics'
#       redirect_to "/units/#{unit_id}"
#     end
#   end
#
#   def create
#     @topic = Topic.find(params[:topic_id])
#     unit_id = @topic.unit.id
#     @topic.lessons.create_with_user(lesson_params,current_user)
#     redirect_to "/units/#{unit_id}"
#   end
#
#   def show
#     @lesson = Lesson.find(params[:id])
#   end
#
#   def edit
#     @lesson = Lesson.find(params[:id])
#     unit_id = @lesson.topic.unit.id
#     if current_user != @lesson.user
#       flash[:notice] = 'You can only edit your own lessons'
#       redirect_to "/units/#{unit_id}"
#     end
#   end
#
#   def update
#     @lesson = Lesson.find(params[:id])
#     unit_id = @lesson.topic.unit.id
#     @lesson.update(lesson_params)
#     redirect_to "/units/#{unit_id}"
#   end
#
#   def destroy
#     @lesson = Lesson.find(params[:id])
#     unit_id = @lesson.topic.unit.id
#     if @lesson.user == current_user
#       @lesson.destroy
#     else
#       flash[:notice] = 'Can only delete your own lessons'
#     end
#     redirect_to "/units/#{unit_id}"
#   end
#
#   def new_question
#     @lesson = Lesson.find(params[:id])
#     @questions = Question.all
#   end
#
#   def create_question
#     lesson = Lesson.find(params[:id])
#     lesson.questions = Question.where(id: params[:question_ids])
#     lesson.save
#     unit_id = lesson.topic.unit.id
#     redirect_to "/units/#{unit_id}"
#   end
#
#
#   def lesson_params
#     params.require(:lesson).permit!
#   end
#
#
# end
