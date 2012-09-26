module ActiveRecord
  class Base
    class << self
      # This clobbers the DB Charmer wrapping of relation and does the same thing except
      # it leaves connection resolution to runtime rather than assigning an instance variable
      def relation_with_db_charmer(*args, &block)
        relation_without_db_charmer(*args, &block).tap do |rel|
          begin
            rel.db_charmer_connection = @connection
          rescue StandardError => e
            base = self
            rel.define_singleton_method(:db_charmer_connection) do
              base.connection
            end
          end
          rel.db_charmer_enable_slaves = self.db_charmer_slaves.any?
          rel.db_charmer_connection_is_forced = !db_charmer_top_level_connection?
        end
      end
      alias relation relation_with_db_charmer
    end
  end
end
