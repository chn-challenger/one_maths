class ManagementController < ApplicationController

  def student_manager
    user = User.where(email:session[:student_email_management]).first
    if current_user && can?(:create, Question)
      if !!user
        questions_records = AnsweredQuestion.where(user_id:user.id).order('created_at')
        @records = { student_id: user.id, units:[], topics:[], lessons:[], courses: [] }
        questions_records.each do |record|
          lesson = Lesson.find(record.lesson_id) unless record.lesson_id.nil? # name: "Sequence and Summation"
          topic = Topic.find(lesson.topic_id) unless lesson.nil? # Chapter name: "Sequence and Series 1"
          unit = Unit.find(topic.unit_id) unless topic.nil?# name: Core 1, description: Edxcel Core 1:  Sequence and summations
          course = Course.find(unit.course_id) unless unit.nil? # Edexcel A Level Maths
          @records[:units] << unit
          @records[:topics] << topic
          @records[:lessons] << lesson
          @records[:courses] << course
        end
        unique_array
      else
        @records = { student_id: "", units:[], topics:[], lessons:[], courses: [] }
      end
    else
      flash[:notice] = 'You do not have permission to edit user records'
      redirect_to root_path
    end
  end

  def edit_student_questions
    if current_user && can?(:edit, AnsweredQuestion)
      lesson = Lesson.find(edit_answered_questions_params[:lesson_id])
      answered_question_records = AnsweredQuestion.where(lesson_id: lesson.id, user_id: edit_answered_questions_params[:user_id])
      @answered_questions = []
      answered_question_records.each do |record|
        correct = record.correct ? "Answered correctly" : "Answered incorrectly"
        @answered_questions << [Question.where(id: record.question_id).first, correct, record.created_at, record.answer, lesson.name, record.id ]
      end
    else
      flash[:notice] = 'You do not have permission to edit answered questions'
      redirect_to '/'
    end
  end

  def delete_student_questions
    if delete_params[:question_ids].nil? || delete_params[:question_ids].empty?
      flash[:notice] = 'No answered questions were selected to be deleted.'
      redirect_back(fallback_location: student_manager_path)
    elsif can?(:delete, AnsweredQuestion)
      AnsweredQuestion.delete(delete_params[:question_ids])
      flash[:notice] = 'Answered Questions have been deleted'
      redirect_back(fallback_location: student_manager_path)
    else
      flash[:notice] = 'You do not have permission to delete answered questions'
      redirect root_path
    end
  end

  def edit_experience
    student_exp_record = experience_params[:exp_type] == 'lesson' ? StudentLessonExp.where(lesson_id: experience_params[:id], user_id: experience_params[:student_id] ) : StudentTopicExp.where(topic_id: experience_params[:id], user_id: experience_params[:student_id] )
    if can?(:edit, student_exp_record)
      student_exp_record.update(exp: experience_params[:exp])
      redirect_to student_manager_path
    else
      flash[:notice] = 'You do not have permission to edit lesson/topic experience'
      redirect_to '/'
    end
  end

  def get_student_management
    session[:student_email_management] = get_student_params[:email]
    redirect_to student_manager_path
  end

  private

  def unique_array
    @records[:units] = @records[:units].uniq.reject { |unit| unit.nil? }
    @records[:topics] = @records[:topics].uniq.reject { |topic| topic.nil? }
    @records[:lessons] = @records[:lessons].uniq.reject { |lesson| lesson.nil? }
    @records[:courses] = @records[:courses].uniq.reject { |course| course.nil? }
  end

  def get_student_params
    params.permit(:email)
  end

  def experience_params
    params.permit(:id, :exp_type, :exp, :student_id)
  end

  def edit_answered_questions_params
    params.permit(:lesson_id, :user_id)
  end

  def delete_params
    params.permit!
  end

end
