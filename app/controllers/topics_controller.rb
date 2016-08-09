class TopicsController < ApplicationController

  def new
    @unit = Unit.find(params[:unit_id])
    if @unit.maker == current_maker
      @topic = @unit.topics.new
    else
      flash[:notice] = 'You can only add topics to your own unit'
      redirect_to "/units/#{@unit.id}"
    end
  end

  def create
    @unit = Unit.find(params[:unit_id])
    @unit.topics.create_with_maker(topic_params,current_maker)
    redirect_to "/units/#{@unit.id}"
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def edit
    @topic = Topic.find(params[:id])
    unit_id = @topic.unit.id
    if current_maker != @topic.maker
      flash[:notice] = 'You can only edit your own topics'
      redirect_to "/units/#{unit_id}"
    end
  end

  def update
    @topic = Topic.find(params[:id])
    unit_id = @topic.unit.id
    @topic.update(topic_params)
    redirect_to "/units/#{unit_id}"
  end

  def destroy
    @topic = Topic.find(params[:id])
    unit_id = @topic.unit.id
    if @topic.maker == current_maker
      @topic.destroy
    else
      flash[:notice] = 'Can only delete your own topics'
    end
    redirect_to "/units/#{unit_id}"
  end

  def topic_params
    params.require(:topic).permit!
  end

end
