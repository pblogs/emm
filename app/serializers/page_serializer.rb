class PageSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :weight, :default

  has_many :tiles, serializer: UserTilesSerializer

  def include_tiles?
    options[:with_tiles]
  end

  def tiles
    object.tiles.includes(content: :user)
  end
end
