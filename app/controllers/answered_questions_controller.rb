class AnsweredQuestionsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  skip_authorize_resource only: :destroy

  def answered_questions
    user = User.where(email:session[:student_email]).first
    if !user.blank? && can?(:create, Question)
      if (session[:from_date] != "") && (session[:to_date] != "")
        time_range = (Time.parse(session[:from_date])..Time.parse(session[:to_date]))
      else
        time_range = ((Time.now - (7*24*60*60))..Time.now)
      end
      questions_records = AnsweredQuestion.where(user_id:user.id, created_at: time_range ).order('created_at')
      @answered_questions = []
      questions_records.each do |record|
        correct = record.correct ? "Answered correctly" : "Answered incorrectly"
        @answered_questions << [Question.where(id: record.question_id).first, correct, record.created_at, record.answer]
      end
    else
      @answered_questions = []
    end
  end

  def get_student
    session[:student_email] = params[:email]
    session[:from_date] = params[:from_date]
    session[:to_date] = params[:to_date]
    redirect_to "/answered_questions"
  end

  def destroy
    answered_question = AnsweredQuestion.find_by(question_id: params[:question_id], user_id: current_user.id)
    if can? :delete, answered_question
      if answered_question.destroy
        flash[:notice] = "Successfully deleted an answered question."
      end
    end
    redirect_back(fallback_location: root_path)
  end
end
