module ActiveRecord
  module ModelSchema
    module ClassMethods
      def table_exists_with_wraithdb_columns?
        begin
          table_exists_without_wraithdb_columns?
        rescue
          WraithDB.schema.tables.has_key?(table_name.to_s)
        end
      end
      alias_method_chain :table_exists?, :wraithdb_columns

      def columns_with_wraithdb_columns
        begin
          columns_without_wraithdb_columns
        rescue
          columns = WraithDB.schema.tables[table_name.to_s].columns
          return columns.map {|column|
            WraithDB::Column.new(column)
          }
        end
      end
      alias_method_chain :columns, :wraithdb_columns
    end
  end
end

