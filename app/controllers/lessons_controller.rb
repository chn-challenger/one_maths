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
    @redirect = request.referer
    @question = Question.new
    @lesson = Lesson.find(params[:id])
    @questions = Question.all
    unless can? :create, @lesson
      flash[:notice] = 'You do not have permission to add questions to lesson'
      redirect_to "/units/#{ @lesson.topic.unit.id }"
    end
  end

  def create_question
    lesson = Lesson.find(params[:id])
    if can? :create, lesson
      lesson.questions = Question.where(id: params[:question_ids])
      lesson.save
    else
      flash[:notice] = 'You do not have permission to add questions to lesson'
    end
    redirect_to "/units/#{lesson.topic.unit.id}"
  end

  def next_question
    lesson = Lesson.find(params[:id])
    next_question = lesson.random_question(current_user)
    CurrentQuestion.create(user_id: current_user.id, lesson_id: lesson.id, question_id: next_question.id)
    choices = next_question.choices
    render json:{question: next_question, choices: choices}
  end

  def lesson_params
    params.require(:lesson).permit!
  end
end
