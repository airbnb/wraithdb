module WraithDB
  module Adapters
    class Sqlite3Adapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
      WraithFunc_Init = WraithFunctionality.instance_method(:initialize)
      include WraithFunctionality

      def initialize
        WraithFunc_Init.bind(self).call
        super()
      end

      def override_connection?
        true
      end

      def columns(table_name, name)
        if table_exists?(table_name)
          @tables[table_name].columns.map { |c| WraithDB::Column.new(c) }
        else
          []
        end
      end

      def table_exists?(name)
        @tables.has_key?(name.to_s)
      end

      def adapter_name
        'WraithSqlite3'
      end
    end
  end
end
