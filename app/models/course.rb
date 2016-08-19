class Course < ApplicationRecord
  belongs_to :user
  # has_many :units

  # has_many :units do
  #   def build_with_maker(attributes = {}, maker)
  #     attributes[:maker] ||= maker
  #     build(attributes)
  #     # unit = units.build(attributes)
  #     # unit.maker = maker
  #     # unit
  #   end
  # end

  has_many :units,
        -> { extending WithUserAssociationExtension },
        dependent: :destroy
end
