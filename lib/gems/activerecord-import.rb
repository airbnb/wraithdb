module ActiveRecord
  class Base
    class << self
      def establish_connection_with_activerecord_import(*args)
        establish_connection_without_activerecord_import(*args)
        begin
          # Only compatible with ActiveRecord::Import >= 0.3.0, unfortunately,
          # ActiveRecord::Import does not make version information available in
          # the standard way
          ActiveSupport.run_load_hooks(:active_record_connection_established, connection_pool)
        rescue StandardError => e
          # ActiveImport will not work but this shouldn't be an issue as it's 
          # only used in Rake tasks. If the DB is down we won't be importing
          # anything in a rake task anyhow.
          logger.info(
            "[wraithdb] Running ActiveRecord::Import hook failed: " +
            "#{e.inspect} (#{e.backtrace.first})")
        end
      end
      alias establish_connection establish_connection_with_activerecord_import
    end
  end
end
