class TopicsController < ApplicationController
  include AnswersSupport

  before_action :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource only: [:show, :next_question]

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @unit = Unit.find(params[:unit_id])
    if can? :create, Topic
      if current_user.has_role?(:teacher) && @unit.course.owner != current_user
        flash[:notice] = 'You can only add Topic to your own course'
        redirect_to courses_path
      else
        @topic = @unit.topics.new
      end
    else
      flash[:notice] = 'You do not have permission to add a topic'
      redirect_to "/units/#{@unit.id}"
    end
  end

  def create
    unit = Unit.find(params[:unit_id])
    topic = unit.topics.new(topic_params)
    if topic.save
      flash[:notice] = "Topic #{topic.name} for unit #{unit.name} has been created."
    else
      flash[:alert] = "There was an error in saving the topic. #{topic.errors}"
    end
    redirect_to "/units/#{unit.id}"
  end

  def edit
    @topic = Topic.find(params[:id])
    unit_id = @topic.unit.id
    unless can? :edit, @topic
      flash[:notice] = 'You do not have permission to edit a topic'
      redirect_to "/units/#{unit_id}"
    end
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update(topic_params)
    redirect_to "/units/#{@topic.unit.id}"
  end

  def destroy
    topic = Topic.find(params[:id])
    if can? :delete, topic
      topic.destroy
      flash[:notice] = 'Topic deleted successfully'
    else
      flash[:notice] = 'You do not have permission to delete a topic'
    end
    redirect_to "/units/#{topic.unit.id}"
  end

  def new_question
    @topic = Topic.find(params[:id])
    current_questions = @topic.questions
    unused_questions = Question.unused
    @questions = current_questions + unused_questions
    unless can? :create, @topic
      flash[:alert] = 'You do not have permission to add questions to chapter'
      redirect_to "/units/#{ @topic.unit.id }"
    end
  end

  def create_question
    topic = Topic.find(params[:id])
    topic.questions = Question.where(id: params[:question_ids])
    if topic.save
      flash[:notice] = 'Questions successfully added to topic.'
    else
      flash[:alert] = 'You do not have permission to add questions to chapter'
    end
    redirect_to "/units/#{topic.unit.id}"
  end

  def next_question
    topic = Topic.find(params[:id])
    next_question = topic.random_question(current_user)

    if next_question.nil?
      next_question = ""
      choices = []
      answers = []
      topic_bonus_exp = 0
    else
      CurrentTopicQuestion.create(user_id: current_user.id, topic_id: topic.id, question_id: next_question.id)
      choices = next_question.choices.shuffle
      answers = set_hint(next_question.answers.order(:order))
      topic_bonus_exp = (StudentTopicExp.get_streak_bonus(current_user, topic) * next_question.experience).to_i
    end

    if choices.first.present? && choices.first.images.length > 0
      choices_urls = []
      choices.each do |choice|
        choices_urls << choice.images.first.picture.url(:medium).to_s
      end
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

    render json:  { question: next_question,
                    choices: choices,
                    choices_urls: choices_urls,
                    answers: answers,
                    topic_bonus_exp: topic_bonus_exp,
                    question_image_urls: question_image_urls }
  end

  private

    def topic_params
      params.require(:topic).permit!
    end
end
