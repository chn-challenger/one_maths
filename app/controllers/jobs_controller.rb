class JobsController < ApplicationController
  include JobsHelper

  before_action :authenticate_user!
  before_action :check_expired_jobs, only: [:show, :index]
  # before_action :invalid_example_id, only: :create
  load_and_authorize_resource

  skip_authorize_resource only: [:assign, :reset_exp, :create, :update]

  def index
    @jobs = Job.all.order('created_at')
  end

  def show
    if can? :read, Job
      @job = Job.find(params[:id])
      @job_example = @job.examples.first
      @job_images = @job.images

      if !@job.worker_id.nil? || current_user.admin? || current_user.super_admin?
        @comment = Comment.new
        render 'show_assigned'
      elsif (@job.worker_id.nil? || @job.worker_id == 0) && !@job.archived?
        render 'show'
      else
        flash[:notice] = 'You cannot view this page.'
        redirect_to jobs_path
      end
    end
  end

  def new
    @job = Job.new
    image = @job.images.build
    unless can? :create, @job
      flash[:notice] = 'Only admins can access this page'
      redirect_to "/"
    end
  end

  def archive
    @jobs = fetch_archived_jobs
  end

  def review
    @jobs = fetch_pending_jobs
  end

  def assign
    job = Job.find(params[:id])
    if (current_user.assignment.include?(job) || current_user.admin? || current_user.super_admin?) && params[:type] == 'cancel'
      job.update(status: nil, worker_id: nil)
      redirect_to(jobs_path)
      flash[:notice] = 'You have successfully canceled the job.'
    elsif can?(:read, Job) && current_user.assignment.size < 3
      job.update(assign_params)
      flash[:notice] = 'You have successfully taken the job.'
      redirect_back(fallback_location: jobs_path)
    else
      flash[:notice] = 'You do not have permission to take this job or you have reached the limit of 3 jobs.'
      redirect_back(fallback_location: jobs_path)
    end
  end

  def reset_exp
    user = User.find(params[:user_id])
    unit = Unit.find(params[:unit_id])
    topic_id = unit.topics.last.id
    lesson_id = Lesson.find_by(topic_id: topic_id).id
    if user
      answered_questions = AnsweredQuestion.where(user: user, lesson_id: lesson_id)
      lesson_exp = user.student_lesson_exps.where(lesson_id: lesson_id).first
      topic_exp = user.student_topic_exps.where(topic_id: topic_id).first
      if !!lesson_exp && !!topic_exp
        topic_exp.update(exp: 0)
        lesson_exp.update(exp: 0)
        AnsweredQuestion.delete(answered_questions)
        flash[:notice] = 'You have successfully reset the questions.'
      else
        flash[:notice] = 'You have not answered any questions.'
      end
    else
      flash[:notice] = 'You do not have permission to reset questions.'
    end
    redirect_back(fallback_location: jobs_path)
  end

  def question
    @job_question = Question.find(params[:id])
    @job_example = get_example_question(params[:id])
  end

  def destroy
    job = Job.find(params[:id])
    if can? :delete, Job
      job.destroy
      flash[:notice] = "Successfully deleted the job."
    else
      flash[:notice] = "You do not have permission to delete jobs!"
    end
    redirect_back(fallback_location: jobs_path)
  end

  def create
    if can? :create, Job
      job = Job.new(job_params)

      questions_num = params[:questions]
      questions_num ||= 3

      job.job_questions << create_job_questions(questions_num)

      if job.save!
        job_questions = job.job_questions
        job.unit = create_job_test_env(job_questions, job.id)
        flash[:notice] = "You have successfully created a job listing."
      else
        flash[:notice] = 'Something went wrong when saving the job listing, please review console.'
      end

      unless !(!!job_params[:example_id]) || job_params[:example_id] == ""
        if Question.exists?(job_params[:example_id])
          example_question = Question.find(id_extractor(job_params[:example_id]))
          job.examples << example_question
        else
          flash[:notice] = "You have not entered valid Example ID please update the job."
        end
      end

      if !!params[:example_image] && params[:example_image] != []
        params[:example_image].each do |image|
          job.images << Image.create!(picture: image)
        end
      end

    else
      flash[:notice] = 'Only admins can create a job'
    end
    redirect_to jobs_path
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    job = Job.find(params[:id])

    if job.update_attributes(job_params)
      unless job_params[:example_id].nil?
        example_question = Question.find(id_extractor(job_params[:example_id]))
        job.examples << example_question
      end

      if !!params[:example_image] && params[:example_image] != []
        params[:example_image].each do |image|
          job.images << Image.create!(picture: image)
        end
      end
    else
      flash[:notice] = "Something has gone wrong in updating please check the logs!"
    end
    redirect_to job_path(job)
  end

  def approve_job
    job = Job.find(params[:id])

    if params[:approve] == 'true'
      job.update_attributes(worker_id: nil, status: 'Archived', completed_by: job.worker_id)
      job.job_questions.
  end

  private

  def job_params
    params.require(:job).permit(:name, :description,
                                :example_id, :price,
                                :duration, :creator_id,
                                :status, :completed_by,
                                images_attributes: [:picture]
    )
  end

  def image_params
    params.permit(example_image: [])
  end

  def assign_params
    params.permit(:status, :worker_id)
  end

  def reset_exp_params
    params.permit(:user_id, :id)
  end

  def check_expired_jobs
    Job.where.not(worker_id: nil).each do |job|
      next if job.status == "Pending Review"
      job.update(worker_id: nil, status: nil) if Time.now > job.due_date
    end
  end

  def invalid_example_id
    unless Question.exists?(id: id_extractor(job_params[:example_id]))
      flash[:notice] = "You need to enter valid Example ID."
      redirect_back(fallback_location: jobs_path)
    end
  end
end
