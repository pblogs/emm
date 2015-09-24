class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :cover, :location_name, :latitude, :longitude, :start_date, :end_date,
             :created_at
end
