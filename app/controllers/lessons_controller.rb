class LessonsController < ApplicationController
  include AnswersSupport

  before_action :authenticate_user!

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
    @topic = Topic.find(params[:topic_id])
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
    questions_with_no_lessons = Question.without_lessons
    questions_current_lesson = Question.includes(:lessons).where(lessons: {id: @lesson.id})
    questions_collection = (questions_with_no_lessons + questions_current_lesson)
    @questions = questions_collection.inject([]){|arry, q| arry << q }
    @questions.sort! do |x, y|
      x_lesson = x.lessons.length > 0 ? x.lessons.first.id : 99999
      y_lesson = y.lessons.length > 0 ? y.lessons.first.id : 99999
      [x_lesson,x.order] <=> [y_lesson,y.order]
    end
    unless can? :create, @lesson
      flash[:notice] = 'You do not have permission to add questions to lesson'
      redirect_to "/units/#{ @lesson.topic.unit.id }"
    end
  end

  def create_question
    lesson = Lesson.find(params[:id])
    if can? :create, lesson
      lesson.question_ids = params[:question_ids]
      lesson.save
    else
      flash[:notice] = 'You do not have permission to add questions to lesson'
    end
    redirect_to "/units/#{lesson.topic.unit.id}"
  end

  def next_question
    lesson = Lesson.find(params[:id])
    next_question = lesson.random_question(current_user)

    if next_question.nil?
      next_question = ""
      choices = []
      choices_urls = []
      answers = []
      lesson_bonus_exp = 0
    else
      CurrentQuestion.create(user_id: current_user.id, lesson_id: lesson.id, question_id: next_question.id)
      choices = next_question.choices.shuffle

      if !choices.first.blank? && choices.first.images.length > 0
        choices_urls = []
        choices.each do |choice|
          choices_urls << choice.images.first.picture.url(:medium).to_s
        end
      end

      answers = set_hint(next_question.answers.order('created_at'))
      lesson_streak_mtp = StudentLessonExp.get_streak_bonus(current_user, lesson)
      lesson_bonus_exp = ( lesson_streak_mtp * next_question.experience).to_i
    end

    unless next_question.is_a?(String)
      if next_question.question_images.exists?
        question_image_urls = []
        next_question.question_images.each do |image|
          question_image_urls.push(image.picture.url(:medium).to_s)
        end
        question_image_urls
      else
        question_image_urls = []
      end
    end

    result = { question: next_question,
               choices: choices,
               choices_urls: choices_urls,
               answers: answers,
               lesson_bonus_exp: lesson_bonus_exp,
               question_image_urls: question_image_urls,
               lesson_streak_mtp: lesson_streak_mtp
             }

    render json: result
  end

  def remove_question
    question = Question.find(params[:question_id])
    lesson = Lesson.find(params[:lesson_id])
    lesson.questions.delete(question)
    render json: {done: 'done'}
  end

  private

  def lesson_params
    params.require(:lesson).permit(:name, :description, :video,
                                   :pass_experience, :sort_order,
                                   :status)
  end
end
