class PrivateUserSerializer < UserSerializer
  attributes  :id, :first_name, :last_name, :birthday, :email, :unconfirmed_email, :is_confirmed, :role, :created_at

  def is_confirmed
    object.confirmed?
  end
end
