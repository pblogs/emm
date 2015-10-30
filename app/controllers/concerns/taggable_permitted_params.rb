module TaggablePermittedParams

  def taggable_permitted_params(*allowed_attributes, **allowed_hash)
    allowed_attributes << :tags
    allowed_hash.merge!(tags_attributes: [:id, :user_id, :_destroy], replace_tags_attributes: [:user_id])

    params.require(:resource).permit(*allowed_attributes, allowed_hash).tap do |permitted_attrs|
      permitted_attrs[:tags_attributes].each { |ta| ta[:author_id] = current_user.id } if params[:resource][:tags_attributes]
      permitted_attrs[:replace_tags_attributes].each { |ta| ta[:author_id] = current_user.id } if params[:resource][:replace_tags_attributes]
    end
  end
end
