class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birthday, :avatar_url, :background_url

  def avatar_url
    object.avatar
  end

  def background_url
    object.background
  end
end
