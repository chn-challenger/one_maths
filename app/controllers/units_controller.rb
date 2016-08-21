class UnitsController < ApplicationController

  def index
    @course = Course.find(params[:course_id])
    @units = @course.units.all
  end

  def new
    @course = Course.find(params[:course_id])
    if can? :create, Unit
      @unit = @course.units.new
    else
      flash[:notice] = 'You do not have permission to add a unit'
      redirect_to "/courses/#{ @course.id }"
    end
  end

  def create
    if can? :create, Unit
      course = Course.find(params[:course_id])
      course.units.create(unit_params)
    end
    redirect_to "/courses/#{ course.id }"
  end

  def show
    @unit = Unit.find(params[:id])
  end

  def edit
    @unit = Unit.find(params[:id])
    unless can? :edit, @unit
      flash[:notice] = 'You do not have permission to edit a unit'
      redirect_to "/courses/#{ @unit.course.id }"
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
    if can? :delete, @unit
      @unit.destroy
      flash[:notice] = 'Unit deleted successfully'
    else
      flash[:notice] = 'You do not have permission to delete a unit'
    end
    redirect_to "/courses/#{ @unit.course.id }"
  end

  def unit_params
    params.require(:unit).permit!
  end
end
