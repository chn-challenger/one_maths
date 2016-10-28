class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :user

  def index
    @users = User.where.not(id: current_user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params[:user])
    if @user.save!
      flash[:notice] = "User #{@user.email}, has been successfully created."
      redirect_to admin_users_path
    else
      flash[:alert] = "Error occured and the user was not saved, please try again."
      redirect_to new_admin_users_path
    end
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank?
    if @user.update(params[:user].permit!)
      flash[:notice] = "User #{ @user.email } has been successfully updated."
      redirect_to admin_users_path
    else
      flash[:alert] = "User #{ @user.email } has not been updated."
      redirect_back(fallback_location: admin_users_path)
    end
  end

  def destroy
    @user = User.find(user_destroy_params[:id])
    if @user.destroy
      flash[:notice] = "User has been successfully deleted."
      redirect_to admin_users_path
    else
      flash[:alert] = "User has not been deleted."
      redirect_back(fallback_location: admin_users_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
  end

  def user_destroy_params
    params.permit(:id)
  end

end
