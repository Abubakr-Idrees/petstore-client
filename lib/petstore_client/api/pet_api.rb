module PetstoreClient
  module Api
    class PetApi < BaseApi
      def create_pet(pet)
        pet.validate!
        response = post('pet', pet.to_hash)
        Models::Pet.from_hash(response)
      end

      def update_pet(pet)
        pet.validate!
        response = put('pet', pet.to_hash)
        Models::Pet.from_hash(response)
      end

      def get_pet_by_id(pet_id)
        validate_pet_id!(pet_id)
        response = get("pet/#{pet_id}")
        Models::Pet.from_hash(response)
      end

      def delete_pet(pet_id)
        validate_pet_id!(pet_id)
        delete("pet/#{pet_id}")
        true
      end

      private

      def validate_pet_id!(pet_id)
        unless pet_id.is_a?(Integer) && pet_id.positive?
          raise ValidationError, 'pet_id must be a positive integer'
        end
      end
    end
  end
end
