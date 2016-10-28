class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # rescue_from Exception, with: :not_found
  # rescue_from ActionController::RoutingError, with: :not_found

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
    end

    rescue_from CanCan::AccessDenied do |exception|
      flash[:warning] = exception.message
      redirect_to root_path
    end

    def not_found
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
        format.xml { head :not_found }
        format.any { head :not_found }
      end
    end

    def error
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/500", layout: false, status: :error }
        format.xml { head :not_found }
        format.any { head :not_found }
      end
    end
end
