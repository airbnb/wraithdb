module ActiveRecord
  class Base
    class << self
      # This clobbers the DB Charmer wrapping of relation and does the same thing except
      # it leaves connection resolution to runtime rather than assigning an instance variable
      def relation_with_db_charmer(*args, &block)
        relation_without_db_charmer(*args, &block).tap do |rel|
          base = self
          rel.define_singleton_method(:db_charmer_connection) do
            base.connection
          end
          rel.db_charmer_enable_slaves = self.db_charmer_slaves.any?
          rel.db_charmer_connection_is_forced = !db_charmer_top_level_connection?
        end
      end
      alias relation relation_with_db_charmer

      def establish_connection_with_activerecord_import(*args)
        establish_connection_without_activerecord_import(*args)
        begin
          ActiveSupport.run_load_hooks(:active_record_connection_established, connection)
        rescue StandardError => e
          # ActiveImport will not work but this shouldn't be an issue as it's only used in Rake tasks.
          # If the DB is down we won't be importing anything in a rake task anyhow.
        end
      end
      alias establish_connection establish_connection_with_activerecord_import

      #If we do variable binding inside of where clauses on scopes it needs to work without
      #an actual connection. The implementation provided mirrors the Mysql2Adapter
      def replace_bind_variables_with_wraithdb(statement, values)
        begin
          replace_bind_variables_without_wraithdb
        rescue StandardError => e => e
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
