module WraithDB
  module Adapters
    class DefaultAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
      include WraithFunctionality

      def adapter_name
        'WraithDefault'
      end
    end
  end
end
