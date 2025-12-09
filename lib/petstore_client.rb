require 'faraday'
require 'json'

require_relative 'petstore_client/errors'
require_relative 'petstore_client/configuration'
require_relative 'petstore_client/models/category'
require_relative 'petstore_client/models/tag'
require_relative 'petstore_client/models/pet'
require_relative 'petstore_client/models/order'
require_relative 'petstore_client/models/api_response'
require_relative 'petstore_client/api/base_api'
require_relative 'petstore_client/api/pet_api'
require_relative 'petstore_client/api/store_api'
require_relative 'petstore_client/client'

module PetstoreClient
  VERSION = '1.0.0'
end
