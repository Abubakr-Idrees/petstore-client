require 'spec_helper'

RSpec.describe 'Pet API Integration Tests' do
  let(:client) do
    PetstoreClient::Client.new do |config|
      config.api_key = 'special-key'
    end
  end

  let(:base_url) { 'https://petstore.swagger.io/v2' }

  describe 'POST /pet - Create Pet' do
    context 'with valid pet data' do
      it 'creates a pet successfully' do
        pet = PetstoreClient::Models::Pet.new(
          id: 123,
          category: PetstoreClient::Models::Category.new(id: 1, name: 'Dogs'),
          name: 'Fido',
          photo_urls: ['https://example.com/photos/fido-1.jpg'],
          tags: [PetstoreClient::Models::Tag.new(id: 10, name: 'friendly')],
          status: 'available'
        )

        response_body = {
          'id' => 123,
          'category' => { 'id' => 1, 'name' => 'Dogs' },
          'name' => 'Fido',
          'photoUrls' => ['https://example.com/photos/fido-1.jpg'],
          'tags' => [{ 'id' => 10, 'name' => 'friendly' }],
          'status' => 'available'
        }

        stub_request(:post, "#{base_url}/pet")
          .with(
            headers: { 'api_key' => 'special-key', 'Content-Type' => 'application/json' },
            body: pet.to_hash.to_json
          )
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })

        result = client.pet.create_pet(pet)

        expect(result).to be_a(PetstoreClient::Models::Pet)
        expect(result.id).to eq(123)
        expect(result.name).to eq('Fido')
        expect(result.status).to eq('available')
      end
    end

    context 'with invalid pet data' do
      it 'raises ValidationError when name is missing' do
        pet = PetstoreClient::Models::Pet.new(
          photo_urls: ['https://example.com/photos/fido-1.jpg']
        )

        expect { client.pet.create_pet(pet) }.to raise_error(
          PetstoreClient::ValidationError,
          /name is required/
        )
      end

      it 'raises ValidationError when photo_urls is empty' do
        pet = PetstoreClient::Models::Pet.new(
          name: 'Fido',
          photo_urls: []
        )

        expect { client.pet.create_pet(pet) }.to raise_error(
          PetstoreClient::ValidationError,
          /photo_urls is required/
        )
      end
    end
  end

  describe 'GET /pet/{petId} - Get Pet by ID' do
    context 'when pet exists' do
      it 'returns the pet' do
        response_body = {
          'id' => 123,
          'name' => 'Fido',
          'photoUrls' => ['https://example.com/photo.jpg'],
          'status' => 'available'
        }

        stub_request(:get, "#{base_url}/pet/123")
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })

        result = client.pet.get_pet_by_id(123)

        expect(result).to be_a(PetstoreClient::Models::Pet)
        expect(result.id).to eq(123)
        expect(result.name).to eq('Fido')
      end
    end

    context 'when pet does not exist' do
      it 'raises NotFoundError' do
        stub_request(:get, "#{base_url}/pet/999999")
          .to_return(status: 404, body: { 'message' => 'Pet not found' }.to_json, headers: { 'Content-Type' => 'application/json' })

        expect { client.pet.get_pet_by_id(999999) }.to raise_error(
          PetstoreClient::NotFoundError
        )
      end
    end
  end

  describe 'DELETE /pet/{petId} - Delete Pet' do
    context 'when pet exists' do
      it 'deletes the pet successfully' do
        stub_request(:delete, "#{base_url}/pet/123")
          .to_return(status: 200)

        result = client.pet.delete_pet(123)

        expect(result).to be true
      end
    end
  end
end
