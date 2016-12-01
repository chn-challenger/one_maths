module CatalogueHelper
  def get_images_with_tags
    Image.joins(:tags)
  end

  def get_filtered_images(tag_ids)
    Image.joins(:tags).where(tags: { name: tag_ids }).distinct
  end
end
