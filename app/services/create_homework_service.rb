class CreateHomeworkService

  def initialize(params:, student:)
    @params = params
    @student = student
  end

  def create_lesson_homework
    return if @params[:lessons].blank?

    @params[:lessons].each do |id, target_exp|
      lesson = Lesson.find(id)
      @student.homework.create(lesson_id: id, target_exp: target_exp)
    end
  end

  def create_topic_homework
    return if @params[:topics].blank?
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
