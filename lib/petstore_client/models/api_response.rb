module PetstoreClient
  module Models
    class ApiResponse
      attr_accessor :code, :type, :message

      def initialize(attributes = {})
        @code = attributes[:code]
        @type = attributes[:type]
        @message = attributes[:message]
      end

      def to_hash
        { code: @code, type: @type, message: @message }.compact
      end

      def self.from_hash(hash)
        return nil if hash.nil?
        new(
          code: hash['code'] || hash[:code],
          type: hash['type'] || hash[:type],
          message: hash['message'] || hash[:message]
        )
      end
    end
  end
end
