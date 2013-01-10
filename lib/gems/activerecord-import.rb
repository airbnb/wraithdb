module ActiveRecord
  class Base
    class << self
      def establish_connection_with_activerecord_import(*args)
        establish_connection_without_activerecord_import(*args)
        begin
          ActiveSupport.run_load_hooks(:active_record_connection_established, connection)
        rescue StandardError => e
          # ActiveImport will not work but this shouldn't be an issue as it's 
          # only used in Rake tasks. If the DB is down we won't be importing
          # anything in a rake task anyhow.
        end
      end
      alias establish_connection establish_connection_with_activerecord_import
    end
  end
end
