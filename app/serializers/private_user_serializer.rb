class PrivateUserSerializer < UserSerializer
  attributes  :id, :first_name, :last_name, :birthday, :avatar_url, :background_url,
              :email, :unconfirmed_email, :is_confirmed, :role, :created_at

  def avatar_url
    object.avatar
  end

  def background_url
    object.background
  end

  def is_confirmed
    object.confirmed?
  end
end
