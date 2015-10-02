class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :cover_url, :location_name, :latitude, :longitude, :start_date, :end_date,
             :created_at, :photos_count, :videos_count, :texts_count

  has_one :user

  def cover_url
    object.cover
  end
end
