module ContentLikes
  def get_likes(records)
    return nil unless user_signed_in?

    types = {}

    records.compact.each do |record|
      types[record.class.name] ||= []
      types[record.class.name] << record.id
    end

    sql_str = types.collect { |type, values| "(likes.target_type = '#{type}' AND likes.target_id IN (#{values.join(', ')})
                                              AND likes.user_id = #{current_user.id})" }.join(' OR ')

    Like.where(sql_str)
  end
end
