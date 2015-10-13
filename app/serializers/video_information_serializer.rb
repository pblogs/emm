class VideoInformationSerializer < ActiveModel::Serializer
  attributes :title, :content, :remote_picture_url, :video_id, :source_url, :kind
end
