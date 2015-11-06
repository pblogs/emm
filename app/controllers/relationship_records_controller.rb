class RelationshipRecordsController < ApplicationController
  include ContentLikes
  before_filter :load_tag, only: :create

  def index
    relationship = Relationship.find(params[:relationship_id])
    sql_str = allowed_records_query(relationship)
    tags = sql_str.blank? ? Tag.none : Tag.where(sql_str).includes(:target).page(params[:page]).per(params[:per_page])
    render_resources(tags, each_serializer: TagContentSerializer, content_likes: get_likes(tags.map(&:target)), with_likes: user_signed_in?)
  end

  def create
    authorize! :pin_record, @tag

    target = current_user == @tag.user ? duplicate_or_find_record(@tag) : @tag.target
    tile = target.tile || target.create_tile_on_user_page

    render_resource_or_errors(tile)
  end

  private

  def load_tag
    @tag = Tag.find(params[:tag_id])
    raise ::ParamError::NotAcceptableValue.new(:type, @tag.target_type, %w{ Photo Video Text }) if @tag.target_type == 'Album'
  end

  def duplicate_or_find_record(tag)
    target = tag.target

    find_result = tag.target_type.constantize.find_by(original_id: target.id)
    return find_result if find_result

    create_attributes = allowed_keys(target.attributes, %W{ id created_at :updated_at likes_count image preview album_id })
                          .merge(album_id: tag.user.default_album.id, original_id: target.id)
    new_obj = target.class.new(create_attributes)

    case target.class.name
      when 'Video'
        new_obj.preview = target.preview if target.preview?
      when 'Photo'
        new_obj.image = target.image if target.image?
    end

    new_obj.save!
    new_obj
  end

  def allowed_keys(target, keys = [])
    cpy = target.dup
    keys.each { |key| cpy.delete(key) }
    cpy
  end

  #make query for tags, with allowed to current viewer ids of content
  def allowed_records_query(relationship)
    rel_ids = [relationship.sender.id, relationship.recipient.id]
    types = {}

    rel_ids.each do |user_id|
      partner_id = rel_ids.detect { |id| id != user_id }
      privacy = Album.privacies['for_all'] unless user_signed_in? && current_user.is_friend?(user_id)

      [Video, Photo, Text, Album].each do |model|
        name = model.name
        table_name = name.tableize

        records = model.joins("FULL OUTER JOIN tiles ON tiles.content_id = #{table_name}.id AND tiles.content_type = '#{name}'")
                    .joins(:tags)
                    .where("#{table_name}.id IS NOT NULL")

        records = records.joins(:album) if table_name != 'albums'
        records = records.where('albums.user_id = ? AND tags.user_id = ?', user_id, partner_id)
        records = records.where('tiles.id IS NOT NULL OR albums.privacy = ?', privacy) if privacy
        ids = records.pluck(:id).compact

        next if ids.empty?

        types[name] ||= []
        types[name].concat(ids)
      end
    end
    rel_ids_query = rel_ids.join(', ')
    types.collect { |type, values| "(tags.target_type = '#{type}' AND tags.target_id IN (#{values.join(', ')}))" }
      .join(' OR ') + " AND tags.author_id IN (#{rel_ids_query}) AND tags.user_id IN (#{rel_ids_query})"
  end
end
