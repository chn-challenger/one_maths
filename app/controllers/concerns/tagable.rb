module Tagable
  extend ActiveSupport::Concern

  def tag_sanitizer(tag_string)
    tag_string.split(/\s*,\s*/)
  end

  def get_filtered_records(tag_string, class_name)
    return [] if !tag_string
    tag_names = tag_sanitizer(tag_string)
    tags = Tag.where(name: tag_names)

    return [] if tags.empty? || tags.length != tag_names.length

    method = class_name.to_s.downcase + '_ids'
    record_ids = tags.inject(tags[-1].public_send(method)) { |result, tag| result & tag.public_send(method)}

    class_name.find(record_ids)
  end

  def get_records_with_tags(class_name)
    class_name.constantize.joins(:tags)
  end

  def add_tags(record, tag_names)
    tag_names.each do |tag_name|
      next if record.tags.find_by(name: tag_name)
      tag = Tag.where(name: tag_name).first_or_create(name: tag_name)
      record.tags << tag
    end
  end
end
