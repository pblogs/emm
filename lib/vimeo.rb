class Vimeo
  include HTTParty
  base_uri 'https://api.vimeo.com'
  headers "Authorization" => "Bearer #{ENV['VIMEO_ACCESS_TOKEN']}", "Accept" => "application/vnd.vimeo.*+json;version=3.2"

  %w{ get post put delete }.each do |method_name|
    define_method method_name do |*args|
      JSON.parse(self.class.send(method_name, *args))
    end
  end

  %w{ get post put delete }.each do |method_name|
    define_method "#{method_name}_raw" do |*args|
      self.class.send(method_name, *args)
    end
  end

  class << self
    def get_upload_quota
      responce = JSON.parse(self.get('/me'))
      responce['upload_quota'].try(:[], 'space').try(:[], 'free') || 0
    end

    def uploaded_videos(params = {})
      params[:page] ||= 1
      params[:per_page] ||= 50
      params[:sort] ||= 'date'
      params[:direction] ||= 'asc'
      JSON.parse(self.get('/me/videos', query: params))
    end

    def get_video_info(video_id)
      JSON.parse(self.get("/videos/#{video_id}"))
    end

    def make_private(video_id)
      self.patch("/videos/#{video_id}", body: {'privacy.view' => 'disable', 'privacy.embed' => 'whitelist'})
      self.put("/videos/#{video_id}/privacy/domains/#{ENV['HOST']}")
    end

    def delete_video(video_id)
      self.delete("/videos/#{video_id}")
    end

    def generate_ticket
      JSON.parse(self.post('/me/videos?type=streaming'))
    end

    def finish_upload(complete_uri)
      response = self.delete(complete_uri)
      video_id = response.headers['location'].split('/videos/')[1].to_i rescue nil
      video_id
    end
  end
end
