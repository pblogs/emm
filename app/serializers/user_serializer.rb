class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birthday, :avatar_url
end