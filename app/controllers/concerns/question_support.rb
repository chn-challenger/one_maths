module QuestionSupport
  extend ActiveSupport::Concern

  def add_image(question, picture)
    question.question_images << Image.create!(picture: picture)
  end

  def append_to_lesson(question, params)
    l = Lesson.find(lesson_id)
    l.questions << question
    l.save!
  end

  def add_question_tags(question, tags)
    tag_names = tag_sanitizer(tags)
    add_tags(question, tag_names)
  end

end
