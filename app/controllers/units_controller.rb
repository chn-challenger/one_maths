class UnitsController < ApplicationController

  def index
    @course = Course.find(params[:course_id])
    @units = @course.units.all
  end

  def new
    @course = Course.find(params[:course_id])
    if @course.maker == current_maker
      @unit = @course.units.new
    else
      flash[:notice] = 'You can only add units to your own course'
      redirect_to "/courses/#{@course.id}/units"
    end
  end

  def create
    @course = Course.find(params[:course_id])
    unit = @course.units.new(unit_params)
    unit.maker = current_maker
    unit.save
    redirect_to "/courses"
  end

  def show
    @unit = Unit.find(params[:id])
  end

  def edit
    @unit = Unit.find(params[:id])
    if current_maker != @unit.maker
      flash[:notice] = 'You can only edit your own units'
      redirect_to "/courses"
    end
  end

  def update
    @unit = Unit.find(params[:id])
    @unit.update(unit_params)
    redirect_to '/courses'
  end

  def destroy
    @unit = Unit.find(params[:id])
    if @unit.maker == current_maker
      @unit.destroy
    end
    redirect_to '/'
  end

  def unit_params
    params.require(:unit).permit!
  end

end
