class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birthday, :avatar_url, :background_url, :relation_status

  def avatar_url
    object.avatar
  end

  def background_url
    object.background
  end

  def include_relation_status?
    options[:statuses].keys.include?(object.id) if options[:statuses]
  end

  def relation_status
    options[:statuses][object.id]
  end
end
