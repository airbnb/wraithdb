module WraithDB
  class Schema < ActiveRecord::Schema
    class << self
      def write(*args)
        # normally this would be noisy like a migration, this makes it quiet
      end

      def connection
        load
        @connection ||= WraithDB::Adapter.new
      end

      def tables
        connection.tables
      end

      def initialize(*args)
      end

      def load
        return if @loaded
        @loaded = true
        file = ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb"
        source = File.read(file)
        source.sub!(/^ActiveRecord::Schema.define\(:version => \d+\) do/, "")
        source.sub!(/^end\s*\z/, "")

        instance_eval(source)
      end
    end
  end
end
