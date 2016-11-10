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
      if @job.worker_id.nil?
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

  def reset_exp
    user = User.find(params[:user_id])
    unit = Unit.find(params[:id])
    topic_id = unit.topics.last.id
    lesson_id = Lesson.find_by(topic_id: topic_id).id
    if user
      answered_questions = AnsweredQuestion.where(user: user, lesson_id: lesson_id)
      lesson_exp = user.student_lesson_exps.where(lesson_id: lesson_id).first
      topic_exp = user.student_topic_exps.where(topic_id: topic_id).first

      topic_exp.update(exp: 0)
      lesson_exp.update(exp: 0)
      AnsweredQuestion.delete(answered_questions)
      flash[:notice] = 'You have successfully reset the questions.'
    else
      flash[:notice] = 'You do not have permission to reset questions.'
    end
    redirect_back(fallback_location: jobs_path)
  end

  def question
    @job_question = Question.find(params[:id])
    @job_example = get_example_question(params[:id])
    @answers = prep_new_answers(@job_question, 5)
    @choices = prep_new_choices(@job_question, 5)
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

  def reset_exp_params
    params.permit(:user_id, :id)
  end
end
