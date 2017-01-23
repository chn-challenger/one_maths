class TopicsController < ApplicationController

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @unit = Unit.find(params[:unit_id])
    if can? :create, Topic
      @topic = @unit.topics.new
    else
      flash[:notice] = 'You do not have permission to add a topic'
      redirect_to "/units/#{@unit.id}"
    end
  end

  def create
    unit = Unit.find(params[:unit_id])
    topic = unit.topics.create(topic_params)
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
    # @questions = Question.all
    #hotfix - please refactor this!
    used_questions = []
    lessons = Lesson.all
    lessons.each do |lesson|
      lesson.questions.each do |question|
        used_questions << question
      end
    end
    topics = Topic.all
    topics.each do |topic|
      topic.questions.each do |question|
        used_questions << question
      end
    end
    all_questions = Question.all
    # puts "=============="
    # puts "All questions length #{all_questions.length}"
    # puts "=============="
    # puts "=============="
    # puts "Used_questions length #{used_questions.length}"
    # puts "=============="
    @questions = all_questions - used_questions
    # puts "=============="
    # puts @questions.length
    # puts "=============="
    #end hotfix
    unless can? :create, @topic
      flash[:notice] = 'You do not have permission to add questions to chapter'
      redirect_to "/units/#{ @topic.unit.id }"
    end
  end

  def create_question
    topic = Topic.find(params[:id])
    if can? :create, topic
      topic.questions = Question.where(id: params[:question_ids])
      topic.save
    else
      flash[:notice] = 'You do not have permission to add questions to chapter'
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
      answers = next_question.answers
      topic_bonus_exp = (StudentTopicExp.get_streak_bonus(current_user, topic) * next_question.experience).to_i
    end

    render json:  { question: next_question,
                    choices: choices,
                    answers: answers,
                    topic_bonus_exp: topic_bonus_exp }
  end

  private

    def topic_params
      params.require(:topic).permit!
    end
end
