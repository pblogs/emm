class VimeoUpload
  require 'vimeo'
  include ActiveModel::Model
  include ActiveModel::Serialization
  extend ActiveModel::Naming

  attr_accessor :ticket_id, :uri, :upload_link_secure, :complete_uri

  def initialize
    ticket = Vimeo.generate_ticket
    if ticket['error']
      self.errors.add(:base, ticket['error'])
    else
      self.ticket_id = ticket['ticket_id']
      self.uri = ticket['uri']
      self.upload_link_secure = ticket['upload_link_secure']
      self.complete_uri = ticket['complete_uri']
    end
  end

  def self.complete(complete_uri)
    video_id = Vimeo.finish_upload(complete_uri)
    video = VimeoVideo.new(video_id)
    video.make_private!
    video
  end
end
