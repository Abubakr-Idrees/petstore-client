module PetstoreClient
  class Configuration
    attr_accessor :base_url, :api_key, :timeout, :open_timeout

    def initialize
      @base_url = 'https://petstore.swagger.io/v2'
      @api_key = nil
      @timeout = 60
      @open_timeout = 10
    end

    def validate!
      raise ValidationError, 'base_url cannot be nil or empty' if base_url.nil? || base_url.empty?
    end
  end
end
