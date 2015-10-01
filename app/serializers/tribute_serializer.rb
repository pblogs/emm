class TributeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :author_id, :title, :description
end
