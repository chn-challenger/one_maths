class CoursesController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @courses = Course.all
  end

  def new
    @course = current_user.courses.new
  end

  def create
    @course = current_user.courses.create(course_params)
    redirect_to '/courses'
  end

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
    if current_user != @course.user
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
    if current_user == @course.user
      @course.destroy
      flash[:notice] = 'Course deleted successfully'
    else
      flash[:notice] = 'You can only delete your own course'
    end
      redirect_to '/courses'
  end

  def course_params
    params.require(:course).permit!
  end

end
