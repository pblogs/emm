module ResponseHelpers
  def json_response
    JSON.parse(response.body)
  end

  def serialized(obj, serializer = nil, user = @user, options = {})
    serializer ||= "#{ obj.class.name }Serializer".constantize
    serializer.new(obj, { scope: user, root: false }.merge(options)).as_json.with_indifferent_access.to_hash
  end
end
