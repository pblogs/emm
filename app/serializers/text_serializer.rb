class TextSerializer < ContentSerializer
  has_one :user

  def user
    User.find(object.user_id)
  end
end
