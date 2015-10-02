class PhotoSerializer < ContentSerializer
  attributes :image_url

  def image_url
    object.image
  end
end
