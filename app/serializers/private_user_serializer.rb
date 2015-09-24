class PrivateUserSerializer < UserSerializer
  attributes  :id, :first_name, :last_name, :birthday, :avatar_url,
              :email, :unconfirmed_email, :is_confirmed, :role, :created_at

  def is_confirmed
    object.confirmed?
  end
end
