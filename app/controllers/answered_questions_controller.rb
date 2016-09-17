class AnsweredQuestionsController < ApplicationController

  def answered_questions
    user = User.where(email:session[:student_email]).first
    if !!user
      records = AnsweredQuestion.where(user_id:user.id)
      @answered_questions = []
      records.each do |record|
        @answered_questions << [Question.where(id: record.question_id).first, record.correct.to_s]
      end
    else
      @answered_questions = []
    end
  end

  #<% @answered_questions.each do |answered_question|%>

  def get_student
    session[:student_email] = params[:email]
    redirect_to "/answered_questions"
  end

end
