class TeachersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_invitation, only: [:accept_invitation, :decline_invitation]

  def index
    @students = current_user.students || []
    @selected_student = User.find_by(id: session[:student_id])
  end

  # GET
  def invitation
    @invitation = current_user.invitation
  end

  # GET
  def show_unit
    @unit = Unit.find(params[:unit_id])
    @student = User.find(session[:student_id])
  end

  # POST
  def accept_invitation
    teacher = @invitation.sender
    teacher.students << @invitation.invitee
    if @invitation.destroy
      flash[:notice] = "You have successfully accepted #{teacher.email} invitation!"
    else
      flash[:alert] = @invitation.errors
    end
    redirect_to root_path
  end

  # POST
  def invite_user
    invitee = User.find_by(email: params[:email])
    unless invitee.blank?
      invite = Invitation.new(sender_id: current_user.id, invitee_id: invitee.id)
      if invite.save
        flash[:notice] = "Invitation to #{invitee.email} has been successfully sent."
      else
        flash[:alert] = invite.errors
      end
    else
      flash[:alert] = "You have entered an invalid user email, please check and try again."
    end
    redirect_back(fallback_location: teachers_path)
  end

  # POST
  def student_view
    student = User.find_by(email: params[:student][:email])
    session[:student_id] = student.id
    flash[:notice] = "Student #{student.email} has been selected."
    redirect_back(fallback_location: teachers_path)
  end

  # POST
  def set_homework
    student = User.find(session[:student_id])
    homework = CreateHomeworkService.new(params: homework_params, student: student)
    if homework.execute
      flash[:notice] = "Homework successfully set for #{student.email}"
    else
      flash[:alert] = student.errors
    end
    redirect_back(fallback_location: teachers_path)
  end

  # DELETE
  def decline_invitation
    if @invitation.destroy
      flash[:notice] = "You have declined #{@invitation.sender.email} invitation."
    else
      flash[:alert] = @invitation.errors
    end
    redirect_to root_path
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:invitation_id])
  end

  def homework_params
    params.require(:homework).permit(lessons: [], topics: [], target_exp: [])
  end
end
