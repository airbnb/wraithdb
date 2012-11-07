module WraithDB
  module Adapters
    class Default < ActiveRecord::ConnectionAdapters::AbstractAdapter
      include WraithFunctionality

      def adapter_name
        'WraithDefault'
      end
    end
  end
end
