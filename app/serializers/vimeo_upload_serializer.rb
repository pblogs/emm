class VimeoUploadSerializer < ActiveModel::Serializer
  attributes :ticket_id, :uri, :upload_link_secure, :complete_uri
end
