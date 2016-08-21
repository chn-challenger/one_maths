class TopicsController < ApplicationController

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
    unit.topics.create(topic_params)
    redirect_to "/units/#{unit.id}"
  end

  def show
    @topic = Topic.find(params[:id])
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

  def topic_params
    params.require(:topic).permit!
  end

end
