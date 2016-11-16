class JobsController < ApplicationController
  include JobsHelper

  before_action :authenticate_user!
  # before_action :check_expired_jobs, only: [:show, :index]
  # before_action :invalid_example_id, only: :create
  load_and_authorize_resource

  skip_authorize_resource only: [:assign, :reset_exp, :create]

  def index
    @jobs = Job.all.order('created_at')
  end

  def show
    if can? :read, Job
      @job = Job.find(params[:id])
      @job_example = @job.examples.first
      @job_images = @job.images
      if @job.worker_id.nil? || @job.worker_id == 0
        render 'show'
      else
        render 'show_assigned'
      end
    else
      flash[:notice] = 'You cannot view this page.'
      redirect_to jobs_path
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

  def assign
    job = Job.find(params[:id])
    if current_user.assignment.include?(job) && params[:type] == 'cancel'
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

  def create
    if can? :create, Job
      job = Job.new(job_params)
      job.job_questions << create_job_questions(3)

      if job.save!
        job_questions_ids = job.job_questions.pluck(:id)
        job.unit = create_job_test_env(job_questions_ids)
        flash[:notice] = "You have successfully created a job listing."
      else
        flash[:notice] = 'Something went wrong when saving the job listing, please review console.'
        redirect_back(fallback_location: jobs_path)
      end

      unless job_params[:example_id].nil?
        example_question = Question.find(id_extractor(job_params[:example_id]))
        job.examples << example_question
      end

      # unless image_params["0"][:picture].empty?
      #   job.images << Image.create(name: job.name, picture: image_params["0"][:picture][0])
      # end

      # unless image_params[:image_attributes][:picture].empty?  # && url_params[:image_url] == ""
      #
      #   # if url_params[:image_url] != ""
      #   #   image_urls = id_extractor(url_params[:image_url])
      #   #
      #   #   image_urls.each do |image_url|
      #   #     image = Image.new(name: job.name, picture: URI.parse(image_url))
      #   #     job.images << image unless !image.save!
      #   #   end
      #
      #   # else
      #
      #     image_params[:image_attributes][:picture].each do |uploaded_picture|
      #       image = Image.new(name: job.name, picture: uploaded_picture)
      #       job.images << image << unless !image.save!
      #     end
      #
      #   # end
      # end

    else
      flash[:notice] = 'Only admins can create a job'
    end
    redirect_to jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:name, :description,
                                :example_id, :price,
                                :duration, :creator_id,
                                images_attributes: [:picture]
    )
  end

  def image_params
    params.require(:job).require(:images_attributes).permit!
  end

  # def url_params
  #   params.permit(:image_url)
  # end

  def assign_params
    params.permit(:status, :worker_id)
  end

  def reset_exp_params
    params.permit(:user_id, :id)
  end

  def check_expired_jobs
    Job.where.not(worker_id: nil).each do |job|
      if Time.now > job.due_date
        job.update(worker_id: nil, status: nil)
      end
    end
  end

  def invalid_example_id
    unless Question.exists?(id: id_extractor(job_params[:example_id]))
      flash[:notice] = "You need to enter valid Example ID."
      redirect_back(fallback_location: jobs_path)
    end
  end
end
