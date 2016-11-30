module CatalogueHelper
  def get_images_with_tags
    Image.joins(:tags)
  end

  def get_filtered_images(tag_names)
    tags = Tag.where(name: tag_names)
    return [] if tags.empty? || tags.length != tag_names.length
    image_ids = tags.inject(tags[-1].image_ids) { |result, tag| result & tag.image_ids}
    Image.find(image_ids)
  end

  def even?(arr)
    arr.size % 2 == 0
  end

  def tag_sanitizer(tag_string)
    tag_string.split(/\s*,\s*/)
  end
end
