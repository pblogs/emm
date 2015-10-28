class TributeSerializer < LikableContentSerializer
  attributes :id, :user_id, :author_id, :title, :description

  has_one :author
end
