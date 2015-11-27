class ContentSerializer < LikableContentSerializer
  attributes :id, :title, :description, :album_id, :created_at, :tile, :record, :comments_count, :tags_count

  has_one :user

  def include_comments_count?
    object.tile.show_comments_count? if object.tile
  end

  def include_tags_count?
    object.tile.show_tags_count? if object.tile
  end

  def tile
    TileSerializer.new(object.tile, root: false, skip_content: true).as_json if options[:with_tile]
  end

  def record
    RecordSerializer.new(object.record, root: false, skip_content: true).as_json if options[:with_record]
  end
end
