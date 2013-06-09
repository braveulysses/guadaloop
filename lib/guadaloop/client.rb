module Guadaloop
  class Error < StandardError; end
  class InitializationError < RuntimeError; end

  class Client
    include HTTParty
    format :json

    class << self
      def default_api_host
        ENV['GTFS_API_HOST']
      end

      def request(uri)
        r = Client.get(uri)
        if r.success?
          return r.parsed_response
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

    def initialize
      if Client::default_api_host.nil?
        raise InitializationError, "GTFS_API_HOST must be set"
      end
      Client::base_uri "http://#{Client::default_api_host}"
    end
  end
end