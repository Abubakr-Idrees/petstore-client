module PetstoreClient
  module Models
    class Pet
      VALID_STATUSES = %w[available pending sold].freeze

      attr_accessor :id, :category, :name, :photo_urls, :tags, :status

      def initialize(attributes = {})
        @id = attributes[:id]
        @category = attributes[:category]
        @name = attributes[:name]
        @photo_urls = attributes[:photo_urls] || []
        @tags = attributes[:tags] || []
        @status = attributes[:status]
      end

      def validate!
        errors = []
        errors << 'name is required and cannot be empty' if name.nil? || name.to_s.strip.empty?
        errors << 'photo_urls is required and cannot be empty' if photo_urls.nil? || photo_urls.empty?
        errors << "status must be one of: #{VALID_STATUSES.join(', ')}" if status && !VALID_STATUSES.include?(status)
        raise ValidationError, errors.join('; ') unless errors.empty?
      end

      def to_hash
        {
          id: @id,
          category: @category&.to_hash,
          name: @name,
          photoUrls: @photo_urls,
          tags: @tags&.map(&:to_hash),
          status: @status
        }.compact
      end

      def self.from_hash(hash)
        return nil if hash.nil?
        category = hash['category'] || hash[:category]
        tags = hash['tags'] || hash[:tags]
        new(
          id: hash['id'] || hash[:id],
          category: category ? Category.from_hash(category) : nil,
          name: hash['name'] || hash[:name],
          photo_urls: hash['photoUrls'] || hash[:photo_urls] || [],
          tags: tags ? tags.map { |t| Tag.from_hash(t) } : [],
          status: hash['status'] || hash[:status]
        )
      end
    end
  end
end
