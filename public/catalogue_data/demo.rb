require 'nokogiri'
require 'json'

document = Nokogiri::XML(File.read('p3.html'))

# p document

storage = JSON.parse(File.read('data.json'))

def tag_sanitizer(tag_string)
  tag_string.split(/\s*,\s*/)
end

tags = document.css('SPAN')
images = document.css('IMG')
# p images[0].attributes['NAME'].value
i = 0

p tags

results = {
  data: [
    { image_uri: "",
      image_name: "",
      image_tags: []
    }
  ]
}

record = 'core 1'

221.times { |i|
  added_data = storage["data"][i]["image_tags"] << record
  File.write('data.json', JSON.pretty_generate(storage))
}
# while i < images.size do
#   # p images[i].attributes
#   image_name = !!images[i].attributes['NAME'] ? images[i].attributes['NAME'].value : nil
#   record = {
#     image_uri: images[i].attributes['SRC'].value,
#     image_name: image_name,
#     image_tags: tag_sanitizer(tags[i].text)
#   }
#
#   results[:data] << record
#
#   added_data = storage["data"] << record
#   File.write('data.json', JSON.pretty_generate(storage))
#
#   i += 1
# end

p results
