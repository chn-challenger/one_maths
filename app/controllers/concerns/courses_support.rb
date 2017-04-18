module CoursesSupport
  extend ActiveSupport::Concern

  def fetch_courses(user)
    return [] if user.blank?
    if user.has_role?(:teacher)
      user.own_courses
    elsif user.has_role?(:student)
      user.courses
    elsif user.has_role?(:admin, :super_admin)
      Course.status(:private)
    end
  end
end
