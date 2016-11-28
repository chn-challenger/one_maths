module CatalogueHelper
  def get_images_with_tags
    Image.joins(:tags)
  end

  def get_filtered_images(tag_names)
    tags = Tag.where(name: tag_names)
    if even?(tag_names)
      image_ids = tags.each {|tag, next_tag| tag.image_ids & next_tag.image_ids}
      Image.find(image_ids)
    else
      arr_chunks = tags.size - (tags.size % 2)
      tags_array = tags.each_slice(arr_chunks).to_a
      p tags_array
      odd_array = tags_array.pop

      odd_image_ids = []
      odd_array.each do |tag|
        odd_image_ids << tag.image_ids
      end
      p odd_image_ids.flatten

      image_ids = tags_array.each {|tag, next_tag| tag.image_ids & next_tag.image_ids}
      p image_ids
      Image.find(image_ids & odd_image_ids)
    # else
    #   Image.joins(:tags).where(tags: { name: tag_names }).distinct
    # end
    end
  end

  def even?(arr)
    arr.size % 2 == 0
  end

  def tag_sanitizer(tag_string)
    tag_string.split(/\s*,\s*/)
  end
end
