class CreateHomeworkService
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
      target_exp = calculate_target_exp(topic, opts)
      homework = @student.homework.new(topic_id: id, target_exp: target_exp)

      @errors << homework.errors unless homework.save
    end
  end

  def calculate_target_exp(topic, opts={})
    topic_exp_opts = fetch_topic_exp(topic)
    current_exp = topic_exp_opts.exp
    level_one_exp = topic.level_one_exp
    lvl_multiplier = topic.level_multiplier
    selected_lvl = opts[:level].to_i - 1

    total_exp = (0...selected_lvl).to_a.reduce(0) do |r, level|
                  r += level_one_exp * lvl_multiplier**level
                end
    ((total_exp - current_exp) + opts[:target_exp].to_i) + current_exp
  end

  private

  def fetch_topic_exp(topic)
    id = topic.id
    @student.student_topic_exps.where(topic_id: id).first_or_create(topic_id: id, exp: 0, streak_mtp: 1)
  end
end
