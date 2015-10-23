namespace :vimeo_videos do
  require 'vimeo'

  desc 'Removes all videos uploaded to Vimeo that are not attached to any Emmortal video'
  task clear_needless: :environment do
    @emmortal_vimeo_video_ids = Video.pluck(:video_id)
    clear_needless
  end

  private

  def clear_needless(page=1)
    responce = Vimeo.uploaded_videos({page: page, per_page: 50})
    responce['data'].each do |video|
      vimeo_video_id = video['uri'].gsub('/videos/', '')
      unless vimeo_video_id.in? @emmortal_vimeo_video_ids
        puts "deleting #{vimeo_video_id}"
        Vimeo.delete_video(vimeo_video_id)
      end
    end
    clear_needless(page+1) if responce['paging']['next']
  end
end
