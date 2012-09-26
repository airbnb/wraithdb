module WraithDB
  class Schema < ActiveRecord::Schema
    SCHEMA_REGEX = /^ActiveRecord::Schema.define\(:version => \d+\) do/
    END_REGEX = /^end\s*\z/

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
        if (source =~ SCHEMA_REGEX && source =~ END_REGEX)
          source.sub!(SCHEMA_REGEX, "")
          source.sub!(END_REGEX, "")
        else
          raise StandardError.new("Invalid format for #{file}.")
        end

        instance_eval(source)
      end
    end
  end
end
