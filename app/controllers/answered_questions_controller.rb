class AnsweredQuestionsController < ApplicationController

  def answered_questions
    user = User.where(email:session[:student_email]).first
    if current_user && !!user && can?(:create, Question)
      questions_records = AnsweredQuestion.where(user_id:user.id).order('created_at')
      @records = { units:[], topics:[], lessons:[] }
      @answered_questions = []
      questions_records.each do |record|
        lesson = Lesson.find(record.lesson_id) # name: "Sequence and Summation"
        topic = Topic.find(lesson.topic_id) # Chapter name: "Sequence and Series 1"
        unit = Unit.find(topic.unit_id) # name: Core 1, description: Edxcel Core 1:  Sequence and summations
        course = Course.find(unit.course_id) # Edexcel A Level Maths
        @records[:units] << unit
        @records[:topics] << topic
        @records[:lessons] << topic
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
    @records = @records[:units].uniq
    @records = @records[:topics].uniq
    @records = @records[:lessons].uniq
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
