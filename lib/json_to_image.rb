require 'json'

class JsonToImage
  BASE_URI = Rails.root + "public/catalogue_data/"

  attr_accessor :data_file

  def initialize
    @data_file = Rails.root + "public/catalogue_data/data.json"
  end

  def create
    file_data = get_data_from_file
    file_data["data"].each do |item|
      image = Image.new(name: item["image_name"], picture: File.open(BASE_URI + item["image_uri"]))
      if image.save!
        item["image_tags"].each do |tag_name|
          tag = Tag.exists?(name: tag_name) ? Tag.find_by(name: tag_name) : Tag.create!(name: tag_name)
          image.tags << tag
        end
      else
        fail 'Something went wrong in the saving of the image!'
      end
    end
  end


  def get_data_from_file
    JSON.parse(File.read(@data_file))
  end
end
