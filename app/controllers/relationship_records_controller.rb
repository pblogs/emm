class RelationshipRecordsController < ApplicationController
  include ContentLikes

  def index
    relationship = Relationship.find(params[:relationship_id])
    sql_str = allowed_records_query(relationship)
    tags = sql_str.blank? ? Tag.none : Tag.where(sql_str).includes(:target).page(params[:page]).per(params[:per_page])
    render_resources(tags, each_serializer: TagContentSerializer, content_likes: get_likes(tags.map(&:target)), with_likes: user_signed_in?)
  end

  private

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
    types.collect { |type, values| "(tags.target_type = '#{type}' AND tags.target_id IN (#{values.join(', ')}))" }.join(' OR ')
  end
end
