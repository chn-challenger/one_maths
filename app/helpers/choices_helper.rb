module ChoicesHelper

  def choice_label(choice)
     if choice.images.length > 0
      image_tag choice.images.first.picture.url(:medium), class: "choice-image"
     else
      choice.content
     end
  end
end
