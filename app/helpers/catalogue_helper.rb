module CatalogueHelper

  def get_images_with_tags
    Image.joins(:tags)
  end

  def get_filtered_images(tag_ids)
    Image.joins(:tags).where(tags: { id: tag_ids }).uniq
  end

  def tag_sanitizer(tag_string)
    tag_string.split(/\s*,\s*/)
  end
end
