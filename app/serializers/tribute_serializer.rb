class TributeSerializer < LikableContentSerializer
  attributes :id, :user_id, :author_id, :description, :created_at

  has_one :author
end
