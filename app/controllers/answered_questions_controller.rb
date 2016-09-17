class AnsweredQuestionsController < ApplicationController

  def index
    user = User.where(email:session[:student_email]).first
    if !!user
      @answered_questions = AnsweredQuestion.where(user_id:user.id)
    else
      @answered_questions = nil
    end
  end

  def get_student
    session[:student_email] = params[:email]
    redirect_to answered_questions
  end

end
