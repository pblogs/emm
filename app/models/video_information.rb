class VideoInformation
  YOUTUBE_REGEXP = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/
  VIMEO_REGEXP = /https?:\/\/(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|video\/|)(\d+)(?:$|\/|\?)/

  include ActiveModel::Model
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  attr_accessor :title, :content, :remote_picture_url, :source_url, :kind, :video_id
  attr_reader   :errors

  def initialize(source_url)
    @source_url = source_url
    @errors = ActiveModel::Errors.new(self)
  end

  def parse
    begin
      video_info = video_info(@source_url)
      if @kind == :youtube
        video_info = video_info['items'].first
        self.video_id           = video_info['id']
        self.title              = video_info['snippet']['title']
        self.content            = video_info['snippet']['description'].gsub(/\n/, '<br>')
        self.remote_picture_url = video_info['snippet']['thumbnails']['high']['url']
      elsif @kind == :vimeo
        self.video_id           = video_info['video_id']
        self.title              = video_info['title']
        self.content            = video_info['description'].gsub(/\n/, '<br>')
        self.remote_picture_url = video_info['thumbnail_url']
      end
    rescue => e
      self.errors.add(:base, e.message)
    end
    self
  end

  def set_api_url(url)
    return unless url =~ VIMEO_REGEXP || url =~ YOUTUBE_REGEXP

    if url =~ VIMEO_REGEXP
      @kind = :vimeo
      "https://vimeo.com/api/oembed.json?url=#{ url }"
    elsif url =~ YOUTUBE_REGEXP
      @kind = :youtube
      "https://www.googleapis.com/youtube/v3/videos?id=#{ Regexp.last_match(7) }&key=#{ ENV['YOUTUBE_API_KEY'] }&fields=items(id,snippet(title,description,thumbnails))&part=snippet"
    end
  end

  def video_info(url)
    api_url = set_api_url(@source_url)
    uri = URI.parse(api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE #if Rails.env.development? || Rails.env.test?
    data = http.get(uri.request_uri)

    JSON.parse(data.body)
  end
end
