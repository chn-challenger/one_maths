class Settings::SettingsController < ApplicationController
  ONE_MATH_CONFIG_PATH = "#{Rails.root}/config/one_maths_config.yml"

  before_action :authenticate_user!
  before_action :set_settings

  def index; end

  def show; end

  def update
    write_to_config(settings_params)
    flash[:notice] = 'You have successfully updated the settings.'
    redirect_back(fallback_location: settings_index_path)
  end

  def create
    @settings['hints'] << hint_params[:hint]
    write_to_config(@settings)

    flash[:notice] = 'You have successfully added a new hint.'
    redirect_back(fallback_location: settings_index_path)
  end

  def destroy
    @settings['hints'].delete_at(params[:id].to_i)
    write_to_config(@settings)

    flash[:notice] = 'You have successfully deleted a hint.'
    redirect_back(fallback_location: settings_index_path)
  end

  private

  def settings_params
    params.permit(:reward_mtp, :lower_level, :upper_level, :lower_min, :upper_min, hints: [])
  end

  def hint_params
    params.permit(:hint)
  end

  def write_to_config(settings)
    File.open(ONE_MATH_CONFIG_PATH, 'w') do |h|
      h.write settings.to_yaml
    end
  end

  def set_settings
    @settings = load_config
  end

  def load_config
    YAML.load_file ONE_MATH_CONFIG_PATH
  end
end
