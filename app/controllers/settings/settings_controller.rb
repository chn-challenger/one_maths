class Settings::SettingsController < ApplicationController

  before_action :authenticate_user!

  def index
    @settings = YAML.load_file "#{Rails.root}/config/one_maths_config.yml"
  end

  def show
  end

  def update
  end

  def create
  end
end
