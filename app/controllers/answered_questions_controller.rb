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
        # if @records.key?(unit.id)
        #
        # elsif @records[unit.id][:topics].any? { |topic| topic[:id] == topic.id }
        #   @records << construct_topic_entry(lesson, topic)
        # elsif @records[unit.id][:topics][]
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

  private

  def unique_array
    @records[:units] = @records[:units].uniq.reject { |unit| unit.nil? }
    @records[:topics] = @records[:topics].uniq.reject { |topic| topic.nil? }
    @records[:lessons] = @records[:lessons].uniq.reject { |lesson| lesson.nil? }
  end

  # def construct_entry(lesson, topic, unit)
  #   obj[unit.id] = {
  #     id: unit.id,
  #     name: unit.name,
  #     topics: [
  #       {
  #         id: topic.id,
  #         name: topic.name,
  #         lessons: [
  #           {
  #             id: lesson.id,
  #             name: lesson.name
  #           }
  #         ]
  #       }
  #     ]
  #   }
  # end

end
