class AnsweredQuestionsController < ApplicationController

  def answered_questions
    user = User.where(email:session[:student_email]).first
    if current_user && !!user && can?(:create, Question)
      questions_records = AnsweredQuestion.where(user_id:user.id).order('created_at')
      @records = { student_id: user.id, units:[], topics:[], lessons:[] }
      @answered_questions = []
      questions_records.each do |record|
        lesson = Lesson.find(record.lesson_id) unless record.lesson_id.nil? # name: "Sequence and Summation"
        topic = Topic.find(lesson.topic_id) unless lesson.nil? # Chapter name: "Sequence and Series 1"
        unit = Unit.find(topic.unit_id) unless topic.nil?# name: Core 1, description: Edxcel Core 1:  Sequence and summations
        course = Course.find(unit.course_id) unless unit.nil? # Edexcel A Level Maths
        @records[:units] << unit
        @records[:topics] << topic
        @records[:lessons] << lesson
        correct = record.correct ? "Answered correctly" : "Answered incorrectly"
        @answered_questions << [Question.where(id: record.question_id).first, correct, record.created_at, record.answer]
      end
      unique_array
    else
      @answered_questions = []
    end
  end

  def get_student
    session[:student_email] = params[:email]
    redirect_to "/answered_questions"
  end

  def edit_experience
    student_exp_record = params[:exp_type] == 'lesson' ? StudentLessonExp.where(lesson_id: params[:id], user_id: params[:student_id] ) : StudentTopicExp.where(topic_id: params[:id], user_id: params[:student_id] )
    if can?(:edit, student_exp_record)
      student_exp_record.update(exp: experience_params[:exp])
      redirect_to answered_questions_path
    else
      flash[:notice] = 'You do not have permission to create a question'
      redirect_to '/'
    end
  end

  private

  def unique_array
    @records[:units] = @records[:units].uniq.reject { |unit| unit.nil? }
    @records[:topics] = @records[:topics].uniq.reject { |topic| topic.nil? }
    @records[:lessons] = @records[:lessons].uniq.reject { |lesson| lesson.nil? }
  end

  def experience_params
    params.permit(:id, :exp_type, :exp)
  end

end
