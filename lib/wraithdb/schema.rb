module WraithDB
  class Schema < ActiveRecord::Schema
    SCHEMA_REGEX = /^ActiveRecord::Schema.define\(:version => \d+\) do/
    END_REGEX = /^end\s*\z/

    class << self
      def write(*args)
        # normally this would be noisy like a migration, this makes it quiet
      end

      def connection
        @connection ||= build_connection
        load
        @connection
      end

      def build_connection
        type = ActiveRecord::Base.configurations[Rails.env]['adapter']
        type = 'default' unless File.exist?(adapter_path(type))

        require adapter_path(type)

        WraithDB::Adapters.const_get("#{type.capitalize}Adapter").new
      end

      def adapter_path(type)
        "#{File.expand_path('..', __FILE__)}/adapters/#{type}_adapter.rb"
      end

      def tables
        connection.tables
      end

      def load
        return if @loaded
        @loaded = true
        schema_locations = [
          ENV["SCHEMA"],
          "#{Rails.root}/db/#{Rails.env}_schema.rb",
          "#{Rails.root}/db/schema.rb"
        ]
        file = schema_locations.find { |f| f.present? && File.exist?(f) }
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
