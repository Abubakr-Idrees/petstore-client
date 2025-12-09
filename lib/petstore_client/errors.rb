module PetstoreClient
  class Error < StandardError; end

  class ValidationError < Error; end

  class ApiError < Error
    attr_reader :status_code, :response_body

    def initialize(message, status_code = nil, response_body = nil)
      @status_code = status_code
      @response_body = response_body
      super(message)
    end
  end

  class NotFoundError < ApiError; end
  class InvalidRequestError < ApiError; end
  class ConnectionError < Error; end
end
