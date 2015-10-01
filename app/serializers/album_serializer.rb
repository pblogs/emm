class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :cover, :location_name, :latitude, :longitude, :start_date, :end_date,
             :created_at, :photos_count, :videos_count, :texts_count

  has_one :user
end
