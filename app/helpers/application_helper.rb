module ApplicationHelper
  def limit_width
    "nav-units-width" if request.fullpath =~ /unit/
  end

end
