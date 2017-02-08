class CreateHomeworkService

  def initialize(params:, student:)
    @params = params
    @student = student
  end

  def determine_homework_type
    hash = {}

    if @params[:lesson_ids].present?
      hash[:lesson_id]
    end
  end

  def pass_lesson_homework
    return if @params[:lesson_ids].blank?

    @params[:lesson_ids].each do |id|
      lesson = Lesson.find(id)
      current_exp = StudentLessonExp.current_exp(@student, lesson)
      @student.homework.create(lesson_id: id, target_exp: lesson.pass_experience, initial_exp: current_exp)
    end
  end

  def target_exp_homework
    return if @params[:target_exp].blank?

    @params[:target_exp].each do |lesson_id, exp|
      lesson = Lesson.find(lesson_id)
      current_exp = StudentLessonExp.current_exp(@student, lesson)
      target_exp = current_exp + exp

      @student.homework.create(lesson_id: lesson_id, target_exp: target_exp, initial_exp: current_exp)
    end
  end

  def topic_homework
    return if @params[:topics].blank?

    @params[:topics].each do |topic_id, exp|
      topic = Topic.find(topic_id)
      current_exp = StudentTopicExp.find_by(@student, topic).exp
      target_exp = current_exp + exp

      @student.homework.create(topic_id: topic_id, target_exp: target_exp, initial_exp: current_exp)
    end
  end

  def new_homework(hash:)
    @student.new(hash)
  end
end
