class CoursesController < ApplicationController

  def index
    @courses = Course.all.order('sort_order')
  end

  def new
    @course = Course.new
    unless can? :create, @course
      flash[:notice] = 'Only admins can access this page'
      redirect_to "/courses"
    end
  end

  def create
    @course = Course.create(course_params)
    redirect_to '/courses'
  end

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
    unless can? :edit, @course
      flash[:notice] = 'You can only edit your own courses'
      redirect_to "/courses"
    end
  end

  def update
    @course = Course.find(params[:id])
    if course_params[:user_ids].present?
      users = course_params[:user_ids]
      users = users.reject { |e| e == '0' }
      # course_params[:users] = users.map(&:to_i)
      course_params[:user_ids] = users.map(&:to_i)
    end
    @course.update(course_params)
    redirect_to '/courses'
  end

  def destroy
    @course = Course.find(params[:id])
    if can? :delete, @course
      @course.destroy
      flash[:notice] = 'Course deleted successfully'
    else
      flash[:notice] = 'Only admin can delete courses'
    end
      redirect_to '/courses'
  end

  def course_params
    params.require(:course).permit!
  end
end
