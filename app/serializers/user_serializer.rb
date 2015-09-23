class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birthday, :avatar_url

  def birthday
    object.birthday.strftime('%F') if object.birthday.present?
  end
end
