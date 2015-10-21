class SetDefaultForVideosSource < ActiveRecord::Migration
  def change
    change_column_default :videos, :source, 0
  end
end
