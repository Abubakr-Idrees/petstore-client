module PetstoreClient
  module Api
    class StoreApi < BaseApi
      def place_order(order)
        response = post('store/order', order.to_hash)
        Models::Order.from_hash(response)
      end

      def get_order_by_id(order_id)
        validate_order_id!(order_id)
        response = get("store/order/#{order_id}")
        Models::Order.from_hash(response)
      end

      def delete_order(order_id)
        validate_order_id!(order_id)
        delete("store/order/#{order_id}")
        true
      end

      private

      def validate_order_id!(order_id)
        unless order_id.is_a?(Integer) && order_id.positive?
          raise ValidationError, 'order_id must be a positive integer'
        end
      end
    end
  end
end
