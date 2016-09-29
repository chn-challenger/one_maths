class Image < ApplicationRecord
  has_attached_file :picture, :styles => { large:"500x500>",medium:"400x400>" }, default_url: 'missing.png'
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  # belongs_to :questions
  # belongs_to :question
  has_and_belongs_to_many :choices
end
