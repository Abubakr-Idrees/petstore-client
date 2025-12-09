require 'faraday'
require 'json'

module PetstoreClient
  module Api
    class BaseApi
      def initialize(configuration)
        @configuration = configuration
        @configuration.validate!
      end

      private

      def connection
        @connection ||= Faraday.new(url: @configuration.base_url) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
          faraday.options.timeout = @configuration.timeout
          faraday.options.open_timeout = @configuration.open_timeout
        end
      end

      def build_headers
        headers = { 'Content-Type' => 'application/json' }
        headers['api_key'] = @configuration.api_key if @configuration.api_key
        headers
      end

      def get(path, params = {})
        execute_request(:get, path, params: params)
      end

      def post(path, body = {})
        execute_request(:post, path, body: body)
      end

      def put(path, body = {})
        execute_request(:put, path, body: body)
      end

      def delete(path)
        execute_request(:delete, path)
      end

      def execute_request(method, path, params: {}, body: {})
        response = connection.send(method) do |req|
          req.url path
          req.headers.merge!(build_headers)
          req.params = params if method == :get && !params.empty?
          req.body = body.to_json if [:post, :put].include?(method) && !body.empty?
        end
        handle_response(response)
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
        raise ConnectionError, "Connection failed: #{e.message}"
      end

      def handle_response(response)
        case response.status
        when 200..299
          response.body
        when 404
          error_body = response.body || {}
          message = error_body['message'] || 'Resource not found'
          raise NotFoundError.new(message, response.status, response.body)
        when 400, 405
          error_body = response.body || {}
          message = error_body['message'] || 'Invalid request'
          raise InvalidRequestError.new(message, response.status, response.body)
        else
          error_body = response.body || {}
          message = error_body['message'] || "HTTP #{response.status}"
          raise ApiError.new(message, response.status, response.body)
        end
      end
    end
  end
end
