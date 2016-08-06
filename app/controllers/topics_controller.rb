class TopicsController < ApplicationController

  def new
    @unit = Unit.find(params[:unit_id])
    @topic = @unit.topics.new
    # if @course.maker == current_maker
    #   @unit = @course.units.new
    # else
    #   flash[:notice] = 'You can only add units to your own course'
    #   redirect_to "/courses/#{@course.id}/units"
    # end
  end

  def create
    @unit = Unit.find(params[:unit_id])
    # topic = @unit.topics.new(topic_params)
    # topic.maker = current_maker
    # topic.save
    @unit.topics.create_with_maker(topic_params,current_maker)
    redirect_to "/"
  end

  def topic_params
    params.require(:topic).permit!
  end

end
