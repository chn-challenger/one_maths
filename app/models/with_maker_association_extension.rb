module WithMakerAssociationExtension
  def create_with_maker(attributes = {}, maker)
   attributes[:maker] ||= maker
   create(attributes)
  end

  def create_with_maker!(attributes = {}, maker)
   attributes[:maker] ||= maker
   create!(attributes)
  end

  def build_with_maker(attributes = {}, maker)
   attributes[:maker] ||= maker
   build(attributes)
  end
end
