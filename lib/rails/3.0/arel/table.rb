module Arel
  class Table
    def columns_with_wraithdb
      begin
        columns_without_wraithdb
      rescue
        attributes_for WraithDB::Schema.tables[@name].columns
      end
    end
    alias_method_chain :columns, :wraithdb

    class << self
      def table_cache_with_wraithdb(engine)
        begin
          table_cache_without_wraithdb(engine)
        rescue
          tables = {}
          WraithDB::Schema.tables.keys.each do |table_name|
            tables[table_name] = true
          end
          tables
        end
      end
      alias_method_chain :table_cache, :wraithdb
    end
  end
end
