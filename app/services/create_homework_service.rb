class CreateHomeworkService < BaseHomeworkService
  attr_reader :errors

  def initialize(params:, student:)
    @params = params
    @student = student
    @errors = []
  end

  def execute
    create_lesson_homework
    create_topic_homework
  end

  def create_lesson_homework
    return if @params[:lessons].blank?

    @params[:lessons].each do |id, target_exp|
      lesson = Lesson.find(id)
      homework = @student.homework.new(lesson_id: id, target_exp: target_exp)

      @errors << homework.errors unless homework.save
    end
  end

  def create_topic_homework
    return if @params[:topics].blank?

    @params[:topics].each do |id, opts|
      topic = Topic.find(id)
      target_exp = calculate_target_exp(topic, @student, opts)
      homework = @student.homework.new(topic_id: id, target_exp: target_exp)

      @errors << homework.errors unless homework.save
    end
  end

end
