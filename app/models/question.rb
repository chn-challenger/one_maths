class Question < ApplicationRecord

  has_attached_file :solution_image, :styles => { medium:"500x500>" }, default_url: 'missing.png'

  validates_attachment_content_type :solution_image, :content_type => /\Aimage\/.*\Z/
  before_destroy :update_student_exp, prepend: true

  has_and_belongs_to_many :lessons
  has_and_belongs_to_many :topics
  has_many :answered_questions, dependent: :destroy
  has_many :users, through: :answered_questions
  has_many :choices, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :current_questions, dependent: :destroy

  scope :without_lessons, -> {
    includes(:lessons).where(lessons: { id: nil })
  }

  def self.unused
    used_questions = []
    Lesson.all.each do |lesson|
      used_questions += lesson.questions.to_a
      used_questions.uniq!
    end
    Topic.all.each do |topic|
      used_questions += topic.questions.to_a
      used_questions.uniq!
    end
    Question.all.to_a - used_questions
  end

  private

    def update_student_exp
      ansq = AnsweredQuestion.find_by(question_id: self.id)
      lesson = Lesson.find(ansq.lesson_id)
      topic = Topic.find(lesson.topic_id)
      user = User.find(ansq.user_id)
      if !!ansq
        sle = StudentLessonExp.where(lesson_id: ansq.lesson_id, user_id: ansq.user_id).first
        ste = StudentTopicExp.where(topic_id: topic.id, user_id: ansq.user_id).first
        sle.exp = StudentLessonExp.current_exp(user, lesson) - self.experience
        if sle.save!
          ste.exp = StudentTopicExp.current_exp(user, topic) - self.experience
          ste.save!
        end
      end
    end
end
