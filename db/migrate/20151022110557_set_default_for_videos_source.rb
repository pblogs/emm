class SetDefaultForVideosSource < ActiveRecord::Migration
  def self.up
    change_column_default :videos, :source, 0
  end

  def self.down
    change_column_default :videos, :source, nil
  end
end
