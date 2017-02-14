class HomeworkController < ApplicationController

  before_action :authenticate_user!
  before_action :set_student, only: :create

  def index
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  def edit
  end

  def new
  end

  private

  def homework_params
    params.require(:homework).permit(:student_id, :lesson_id, :topic_id, :target_exp)
  end
end
