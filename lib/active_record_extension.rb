module ActiveRecordExtension

  extend ActiveSupport::Concern

  module ClassMethods

    # Updates numeric fields for multiple records in one DB-query
    # Accept:
    #   objects - Hash in format: {1 => {row: 0, col: 0}, 2 => {row: 0, col: 2}, 3 => {row: 1, col: 0}}
    #             where 1, 2, 3 - ids of objects to update, :row, :col - columns to update.
    #             Columns should be equal for each record and should be in same order for each object
    #             Only numeric values are allowed
    def mass_update(objects, filters={})
      table_name = self.name.tableize

      all_numeric = objects.values.all? do |update_params|
        update_params.values.all? { |val| val.is_a? Numeric }
      end
      return false unless all_numeric

      # virtual_table: "(1,0,0),(2,0,2),(3,1,0)"
      virtual_table = objects.map { |(id, update_data)| "(#{id},#{update_data.values.join(',')})" }.join(',')

      # fields: [:name, :weight]
      fields = objects.values.first.keys

      sql = "UPDATE #{table_name} " +
          "SET " + fields.map { |field| "#{field} = virtual_table.#{field}" }.join(', ') +
          " FROM (values #{virtual_table}) virtual_table(id, #{fields.join(', ')})" +
          " WHERE #{table_name}.id = virtual_table.id " +
          filters.map { |field, value| "AND #{table_name}.#{field} = #{value}" }.join(' ')

      ActiveRecord::Base.connection.execute(sql)
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)
