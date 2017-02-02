class TeachersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_invitation, only: [:accept_invitation, :decline_invitation]

  def index

  end

  # GET
  def invitation
    @invitation = current_user.invitation
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
end
