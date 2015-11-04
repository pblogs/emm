class TributeSerializer < LikableContentSerializer
  attributes :id, :user_id, :author_id, :description, :created_at, :tile

  has_one :author

  def tile
    TileSerializer.new(object.tile, root: false, skip_content: true).as_json if options[:with_tile]
  end
end
