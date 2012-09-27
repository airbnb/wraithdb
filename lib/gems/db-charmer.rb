module ActiveRecord
  class Base
    class << self

      def relation_with_wraith_charmed(*args, &block)
        begin
          relation_without_wraith_charmed(*args, &block)
        rescue StandardError => e
          # This leaves connection resolution for db_charmer to runtime rather than assigning an
          # instance variable
          base = self
          rel = relation_without_db_charmer
          rel.define_singleton_method(:db_charmer_connection) do
            base.connection
          end
          rel.db_charmer_enable_slaves = self.db_charmer_slaves.any?
          rel.db_charmer_connection_is_forced = !db_charmer_top_level_connection?
          rel
        end
      end
      alias_method_chain :relation, :wraith_charmed
    end
  end
end
