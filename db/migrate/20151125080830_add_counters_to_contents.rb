class AddCountersToContents < ActiveRecord::Migration
  def change
    %i{ texts photos videos albums }.each do |target|
      add_column target, :tags_count, :integer, default: 0
      add_column target, :comments_count, :integer, default: 0
    end

    %i{ tributes relationships}.each do |target|
      add_column target, :comments_count, :integer, default: 0
    end
  end
end
