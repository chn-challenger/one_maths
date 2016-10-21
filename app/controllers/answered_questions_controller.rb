require 'time'

class AnsweredQuestionsController < ApplicationController

  def answered_questions
    user = User.where(email:session[:student_email]).first
    if current_user && !!user && can?(:create, Question)
      if !!session[:from_date] && !!session[:to_date]
        time_range = (Time.parse(session[:from_date])..Time.parse(session[:to_date]))
      else
        time_range = 
      records = AnsweredQuestion.where(user_id:user.id, created_at: time_range ).order('created_at')
      @answered_questions = []
      records.each do |record|
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

end
