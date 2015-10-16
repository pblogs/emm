class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :cover_url, :location_name, :latitude, :longitude, :start_date, :end_date,
             :created_at, :photos_count, :videos_count, :texts_count, :color, :privacy, :tile, :records_count

  has_one :user

  def cover_url
    object.cover
  end

  def tile
    TileSerializer.new(object.tile, root: false, skip_content: true).as_json if options[:with_tile]
  end

  def records_count
    object.photos_count + object.videos_count + object.texts_count
  end

end
