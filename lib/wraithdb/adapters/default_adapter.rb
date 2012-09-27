module WraithDB
  module Adapters
    class Mysql2Adapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
      include WraithFunctionality

      def adapter_name
        'WraithDefault'
      end
    end
  end
end
