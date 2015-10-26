class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :album_id, :created_at, :tile, :record , :likes_count

  has_one :user

  def tile
    TileSerializer.new(object.tile, root: false, skip_content: true).as_json if options[:with_tile]
  end

  def record
    RecordSerializer.new(object.record, root: false, skip_content: true).as_json if options[:with_record]
  end
end
