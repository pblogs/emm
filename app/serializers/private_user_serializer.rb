class PrivateUserSerializer < UserSerializer
  attributes :email, :unconfirmed_email, :is_confirmed, :role, :created_at

  def is_confirmed
    object.confirmed?
  end
end
