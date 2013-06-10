module Guadaloop
  class Error < StandardError; end
  class InitializationError < RuntimeError; end

  class Client
    include HTTParty
    format :json

    attr_accessor :raw

    class << self
      def api_host
        ENV['GTFS_API_HOST']
      end

      def initialize_api_host
        if Client::api_host.nil?
          raise InitializationError, "GTFS_API_HOST must be set"
        end
        Client::base_uri "http://#{Client::api_host}"
      end

      def request(uri)
        r = Client.get(uri)
        if r.success?
          return r.parsed_response.map { |obj| yield obj }
        else
          raise_error(r)
        end
      end

      def raise_error(response)
        # TODO: Include the original exception
        error = "HTTP #{response.code} received"
        raise Guadaloop::Error, error
      end
    end

    def method_missing(key)
      if @raw.key? key.to_s
        @raw[key.to_s]
      else
        nil
      end
    end

    initialize_api_host

  end
end
