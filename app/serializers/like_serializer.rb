class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :target_type

  has_one :target
  has_one :user

  def include_target?
    options[:notifications]
  end

  def include_user?
    options[:notifications]
  end
end
