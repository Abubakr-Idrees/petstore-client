module PetstoreClient
  module Models
    class Category
      attr_accessor :id, :name

      def initialize(attributes = {})
        @id = attributes[:id]
        @name = attributes[:name]
      end

      def to_hash
        { id: @id, name: @name }.compact
      end

      def self.from_hash(hash)
        return nil if hash.nil?
        new(
          id: hash['id'] || hash[:id],
          name: hash['name'] || hash[:name]
        )
      end
    end
  end
end
