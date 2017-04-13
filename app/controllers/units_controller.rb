class UnitsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_admin_view_session, only: :show
  skip_before_action :verify_authenticity_token

  def index
    @course = Course.find(params[:course_id])
    @units = @course.units.all
  end

  def new
    @course = Course.find(params[:course_id])
    if can? :create, Unit
      if current_user.has_role?(:teacher) && @course.owner != current_user
        flash[:alert] = 'You can only add units to your own course.'
        redirect_to "/courses/#{ @course.id }"
      else
        @unit = @course.units.new
      end
    else
      flash[:notice] = 'You do not have permission to add a unit'
      redirect_to "/courses/#{ @course.id }"
    end
  end

  def create
    course = Course.find(params[:course_id])
    if can? :create, Unit
      if current_user.has_role?(:teacher) && course.owner != current_user
        flash[:alert] = 'You can only add units to your own course.'
      else
        course.units.create(unit_params)
      end
    end
    redirect_to "/courses/#{ course.id }"
  end

  def show
    @unit = Unit.find(params[:id])
    @hexcolor = @unit.course.nil? ? '72A8FF' : @unit.course.hexcolor
    authorize! :show, @unit
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

  private

  def set_admin_view_session
    session[:admin_view] = true if session[:admin_view].nil? && current_user.has_role?(:admin, :super_admin)
  end
end
