class TagSerializer < ActiveModel::Serializer
  attributes :id, :target_type

  has_one :author
  has_one :user
  has_one :target

  def include_target?
    options[:notifications]
  end
end
