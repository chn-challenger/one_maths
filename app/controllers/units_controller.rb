class UnitsController < ApplicationController

  def index
    # @course = Course.find(params[:id])
    # p params
    @course = Course.find(params[:course_id])
    @units = @course.units.all
  end

end
