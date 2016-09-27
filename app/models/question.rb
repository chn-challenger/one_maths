class Question < ApplicationRecord

  has_attached_file :image, :styles => { large:"450x450", :medium => "300x300>", :thumb => "100x100>" }, default_url: 'missing.png'

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  has_and_belongs_to_many :lessons
  has_and_belongs_to_many :topics
  has_many :answered_questions, dependent: :destroy
  has_many :users, through: :answered_questions
  has_many :choices, dependent: :destroy
  has_many :answers, dependent: :destroy


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

end
