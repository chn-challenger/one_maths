class JobsController < ApplicationController

  def index
    @jobs = Job.all.order('created_at')
  end

  def new
    @job = Job.new
    unless can? :create, @job
      flash[:notice] = 'Only admins can access this page'
      redirect_to "/"
    end
  end

  def show
    if can? :read, Job
      @job = Job.find(params[:id])
      
    else
      flash[:notice] = 'You cannot view this page.'
    end
    redirect_to jobs_path
  end

  def create
    if can? :create, Job
      Job.create(job_params)
    else
      flash[:notice] = 'Only admins can create a job'
    end
    redirect_to '/jobs'
  end

  def show

  end

  def job_params
    params.require(:job).permit(:name, :description, :example_id)
  end
end
