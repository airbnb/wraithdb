module ActiveRecord
  class Base
    class << self
      #If we do variable binding inside of where clauses on scopes it needs to work without
      #an actual connection. The implementation provided mirrors the Mysql2Adapter
      def replace_bind_variables_with_wraithdb(statement, values)
        begin
          replace_bind_variables_without_wraithdb(statement, values)
        rescue StandardError => e
          raise e if e.kind_of? PreparedStatementInvalid
          bound = values.dup
          statement.gsub('?') { quote_bound_value(bound.shift, WraithDB::Schema.connection) }
        end
      end
      alias_method_chain :replace_bind_variables, :wraithdb

      def table_exists_with_wraithdb_columns?
        begin
          table_exists_without_wraithdb_columns?
        rescue StandardError => e
          WraithDB::Schema.tables.has_key?(table_name.to_s)
        end
      end
      alias_method_chain :table_exists?, :wraithdb_columns

      def columns_with_wraithdb_columns
        begin
          columns_without_wraithdb_columns
        rescue StandardError => e
          columns = WraithDB::Schema.tables[table_name.to_s].columns
          return columns.map {|column|
            WraithDB::Column.new(column)
          }
        end
      end
      alias_method_chain :columns, :wraithdb_columns
    end
  end
end
