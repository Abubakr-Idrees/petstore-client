require 'spec_helper'

RSpec.describe 'Store API Integration Tests' do
  let(:client) do
    PetstoreClient::Client.new do |config|
      config.api_key = 'special-key'
    end
  end

  let(:base_url) { 'https://petstore.swagger.io/v2' }

  describe 'POST /store/order - Place Order' do
    context 'with valid order data' do
      it 'places an order successfully' do
        order = PetstoreClient::Models::Order.new(
          id: 987,
          pet_id: 123,
          quantity: 2,
          ship_date: '2025-01-02T10:00:00Z',
          status: 'placed',
          complete: false
        )

        response_body = {
          'id' => 987,
          'petId' => 123,
          'quantity' => 2,
          'shipDate' => '2025-01-02T10:00:00Z',
          'status' => 'placed',
          'complete' => false
        }

        stub_request(:post, "#{base_url}/store/order")
          .with(body: order.to_hash.to_json)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })

        result = client.store.place_order(order)

        expect(result).to be_a(PetstoreClient::Models::Order)
        expect(result.id).to eq(987)
        expect(result.pet_id).to eq(123)
        expect(result.quantity).to eq(2)
      end
    end
  end

  describe 'GET /store/order/{orderId} - Get Order by ID' do
    context 'when order exists' do
      it 'returns the order' do
        response_body = {
          'id' => 987,
          'petId' => 123,
          'quantity' => 2,
          'status' => 'placed'
        }

        stub_request(:get, "#{base_url}/store/order/987")
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })

        result = client.store.get_order_by_id(987)

        expect(result).to be_a(PetstoreClient::Models::Order)
        expect(result.id).to eq(987)
      end
    end

    context 'when order does not exist' do
      it 'raises NotFoundError' do
        stub_request(:get, "#{base_url}/store/order/999999")
          .to_return(status: 404, body: { 'message' => 'Order not found' }.to_json, headers: { 'Content-Type' => 'application/json' })

        expect { client.store.get_order_by_id(999999) }.to raise_error(
          PetstoreClient::NotFoundError
        )
      end
    end
  end

  describe 'DELETE /store/order/{orderId} - Delete Order' do
    context 'when order exists' do
      it 'deletes the order successfully' do
        stub_request(:delete, "#{base_url}/store/order/987")
          .to_return(status: 200)

        result = client.store.delete_order(987)

        expect(result).to be true
      end
    end
  end
end
