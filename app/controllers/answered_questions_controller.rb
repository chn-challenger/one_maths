class AnsweredQuestionsController < ApplicationController

  def answered_questions
    user = User.where(email:session[:student_email]).first
    if current_user && !!user && can?(:create, Question)
      records = AnsweredQuestion.where(user_id:user.id)
      @answered_questions = []
      records.each do |record|
        correct = record.correct ? "Answered correctly" : "Answered incorrectly"
        @answered_questions << [Question.where(id: record.question_id).first, correct]
      end
    else
      @answered_questions = []
    end
  end

  def get_student
    session[:student_email] = params[:email]
    redirect_to "/answered_questions"
  end

end
