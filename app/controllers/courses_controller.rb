class CoursesController < ApplicationController

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.create(course_params)
    redirect_to '/courses'
  end

  def course_params
    params.require(:course).permit!
  end


end
