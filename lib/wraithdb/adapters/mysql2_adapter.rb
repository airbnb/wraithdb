require 'active_record/connection_adapters/mysql2_adapter'

module WraithDB
  module Adapters
    class Mysql2Adapter < ActiveRecord::ConnectionAdapters::Mysql2Adapter
      include WraithFunctionality

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

      # Quotes a string, escaping any ' (single quote) and \ (backslash)
      # characters.
      def quote_string(s)
        s.gsub(/\\/, '\&\&').gsub(/'/, "\\\\'") # ' (for ruby-mode)
      end


      def adapter_name
        'WraithMysql2'
      end
    end
  end
end
