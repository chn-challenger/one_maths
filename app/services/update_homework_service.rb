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
      homework = student.homework.where(lesson_id: id).first
      next if homework.blank?

      exp = target_exp.to_i
      homework.update(target_exp: exp)
    end
  end

  def update_topic_homework

  end

  private

  attr_accessor :params, :student

end
