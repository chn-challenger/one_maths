class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :user

  def index
    @users = User.where.not(id: current_user.id)
  end

  def edit
    @user = User.find(params[:id])
  end
end
