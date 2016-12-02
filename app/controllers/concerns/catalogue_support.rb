module CatalogueSupport
  extend ActiveSupport::Concern

  def tags_setter(params)
    image = Image.find(params[:image_id])
    tag_names = tag_sanitizer(params[:tags]) # Method resides in Tagable module in concerns

    return false if !image && !tag_names.empty?
    add_tags(image, tag_names)
  end

  def new_image(params)
    if params[:image_url] != ""
      Image.new(name: params[:name], picture: URI.parse(params[:image_url]))
    else
      Image.new(name: params[:name], picture: params[:picture])
    end
  end

end
