module WraithDB
  class Column < ActiveRecord::ConnectionAdapters::Column
    def initialize(column_definition)
      @name      = column_definition.name
      @sql_type  = nil
      @null      = column_definition.null
      @limit     = column_definition.limit
      @precision = column_definition.precision
      @scale     = column_definition.scale
      @type      = (column_definition.type == :primary_key) ? :integer : column_definition.type
      @default   = column_definition.default
      @primary   = column_definition.type == :primary_key
      @coder     = nil
    end
  end
end
