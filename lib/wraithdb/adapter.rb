module WraithDB
  class Adapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
    attr_reader :tables

    def initialize
      super(nil)
      @active = true
      @tables = {}
    end

    def quote(value, column = nil)
      if value.kind_of?(String) && column && column.type == :binary && column.class.respond_to?(:string_to_binary)
        s = column.class.string_to_binary(value).unpack("H*")[0]
        "x'#{s}'"
      elsif value.kind_of?(BigDecimal)
        value.to_s("F")
      else
        super
      end
    end

    def adapter_name
      'WraithDB'
    end

    def support_migrations?
      true
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
