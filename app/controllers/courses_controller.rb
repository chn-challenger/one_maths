class CoursesController < ApplicationController

  before_action :authenticate_maker!, :except => [:index, :show]

  def index
    @courses = Course.all
  end

  def new
    @course = current_maker.courses.new
  end

  def create
    @course = current_maker.courses.create(course_params)
    redirect_to '/courses'
  end

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
    if current_maker != @course.maker
      flash[:notice] = 'You can only edit your own courses'
      redirect_to "/courses"
    end
  end

  def update
    @course = Course.find(params[:id])
    @course.update(course_params)
    redirect_to '/courses'
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    flash[:notice] = 'Course deleted successfully'
    redirect_to '/courses'
  end

  def course_params
    params.require(:course).permit!
  end

end
