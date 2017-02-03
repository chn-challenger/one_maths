module TeachersHelper

  def set_as_homework?(lesson, user)
    user.homework.include?(lesson)
  end

end
