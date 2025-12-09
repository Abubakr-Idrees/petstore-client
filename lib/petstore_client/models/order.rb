module PetstoreClient
  module Models
    class Order
      attr_accessor :id, :pet_id, :quantity, :ship_date, :status, :complete

      def initialize(attributes = {})
        @id = attributes[:id]
        @pet_id = attributes[:pet_id]
        @quantity = attributes[:quantity]
        @ship_date = attributes[:ship_date]
        @status = attributes[:status]
        @complete = attributes[:complete]
      end

      def to_hash
        {
          id: @id,
          petId: @pet_id,
          quantity: @quantity,
          shipDate: @ship_date,
          status: @status,
          complete: @complete
        }.compact
      end

      def self.from_hash(hash)
        return nil if hash.nil?
        new(
          id: hash['id'] || hash[:id],
          pet_id: hash['petId'] || hash[:pet_id],
          quantity: hash['quantity'] || hash[:quantity],
          ship_date: hash['shipDate'] || hash[:ship_date],
          status: hash['status'] || hash[:status],
          complete: hash['complete'] || hash[:complete]
        )
      end
    end
  end
end
