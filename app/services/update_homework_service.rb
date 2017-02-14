class UpdateHomeworkService < BaseHomeworkService
  attr_reader :errors

  def initialize(params:, student:)
    @params = params.dup
    @student = student
    @errors = []
  end

  def execute
    update_lesson_homework
    update_topic_homework
  end

  def update_lesson_homework
    return false if params[:lessons].blank?

    params[:lessons].each do |id, target_exp|
      homework = student.homework.find_by(lesson_id: id)
      next if homework.blank?

      exp = target_exp.to_i
      @errors << homework.errors unless homework.update(target_exp: exp)
    end
  end

  def update_topic_homework
    return false if params[:topics].blank?

    params[:topics].each do |id, opts|
      topic = Topic.find(id)
      homework = @student.homework.find_by(topic_id: id)
      next if homework.blank?
      target_exp = calculate_target_exp(topic, @student, opts)

      @errors << homework.errors unless homework.update(target_exp: target_exp.to_i)
    end
  end

  private

  attr_accessor :params, :student

end
