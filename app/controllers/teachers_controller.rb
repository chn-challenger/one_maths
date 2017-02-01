class TeachersController < ApplicationController

  def index

  end

  # POST
  def invite_user
    user = User.find_by(email: params[:email])
    unless user.blank?
      
    else
      flash[:alert] = "You have entered an invalid user email, please check and try again."
    end
    redirect_back(fallback_location: teachers_path)
  end

end
