class UnitsController < ApplicationController

  def index
    @course = Course.find(params[:course_id])
    @units = @course.units.all
  end

  def new
    @course = Course.find(params[:course_id])
    if @course.user == current_user
      @unit = @course.units.new
    else
      flash[:notice] = 'You can only add units to your own course'
      redirect_to "/"
    end
  end

  def create
    @course = Course.find(params[:course_id])
    @unit = @course.units.build_with_user(unit_params,current_user)
    @unit.save
    redirect_to "/courses/#{@course.id}"
  end

  def show
    @unit = Unit.find(params[:id])
  end

  def edit
    @unit = Unit.find(params[:id])
    course_id = @unit.course.id
    if current_user != @unit.user
      flash[:notice] = 'You can only edit your own units'
      redirect_to "/courses/#{course_id}"
    end
  end

  def update
    @unit = Unit.find(params[:id])
    course_id = @unit.course.id
    @unit.update(unit_params)
    redirect_to "/courses/#{course_id}"
  end

  def destroy
    @unit = Unit.find(params[:id])
    course_id = @unit.course.id
    if @unit.user == current_user
      @unit.destroy
    else
      flash[:notice] = 'Can only delete your own units'
    end
    redirect_to "/courses/#{course_id}"
  end

  def unit_params
    params.require(:unit).permit!
  end

end
