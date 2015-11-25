class TributeSerializer < LikableContentSerializer
  attributes :id, :user_id, :author_id, :description, :created_at, :tile, :comments_count

  has_one :author
  has_one :user

  def tile
    TileSerializer.new(object.tile, root: false, skip_content: true).as_json if options[:with_tile]
  end

  def include_user?
    options[:notifications]
  end
end
