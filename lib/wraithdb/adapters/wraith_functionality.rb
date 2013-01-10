module WraithDB
  module Adapters
    module WraithFunctionality
      attr_reader :tables

      def initialize
        @active = true
        @tables = {}
      end

      def support_migrations?
        true
      end

      def override_connection?
        false
      end

      def create_table(table_name, options = {})
        table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(self)
        table_definition.primary_key(options[:primary_key] || ActiveRecord::Base.get_primary_key(table_name.to_s.singularize)) unless options[:id] == false

        yield table_definition if block_given?

        @tables[table_name.to_s] = table_definition
      end

      def add_index(*args)
      end
    end
  end
end
