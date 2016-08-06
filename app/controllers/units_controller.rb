class UnitsController < ApplicationController

  def index
    @course = Course.find(params[:course_id])
    @units = @course.units.all
  end

  def new
    @course = Course.find(params[:course_id])
    @unit = @course.units.new
  end

  def create
    @course = Course.find(params[:course_id])
    unit = @course.units.new(unit_params)
    unit.maker = current_maker
    unit.save
    redirect_to "/courses/#{@course.id}/units"
  end

  def unit_params
    params.require(:unit).permit!
  end

end
