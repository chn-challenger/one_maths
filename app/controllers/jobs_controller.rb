class JobsController < ApplicationController
  include JobsHelper

  before_action :authenticate_user!

  def index
    @jobs = Job.all.order('created_at')
  end

  def show
    if can? :read, Job
      @job = Job.find(params[:id])
      @job_example = @job.examples.first
    else
      flash[:notice] = 'You cannot view this page.'
      redirect_to jobs_path
    end
  end

  def new
    @job = Job.new
    unless can? :create, @job
      flash[:notice] = 'Only admins can access this page'
      redirect_to "/"
    end
  end

  def assign
    job = Job.find(params[:id])
    if can? :edit, Job
      job.update(assign_params)
      flash[:notice] = 'You have successfully accepted the job.'
    else
      flash[:notice] = 'You do not have permission to take this job.'
    end
    redirect_back(fallback_location: jobs_path)
  end

  def create
    if can? :create, Job
      example_question = Question.find(id_extractor(job_params[:example_id]))
      job = Job.new(job_params)
      job.examples << example_question
      job.job_questions << create_job_questions(3)

      if job.save!
        job_questions_ids = job.job_questions.pluck(:id)
        job.unit = create_job_test_env(job_questions_ids)
        flash[:notice] = "You have successfully created a job listing."
      else
        flash[:notice] = 'Something went wrong when saving the job listing, please review console.'
        redirect_back(fallback_location: jobs_path)
      end

    else
      flash[:notice] = 'Only admins can create a job'
    end
    redirect_to jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:name, :description,
                                :example_id, :price,
                                :duration, :creator_id
    )
  end

  def assign_params
    params.permit(:status, :worker_id)
  end
end
