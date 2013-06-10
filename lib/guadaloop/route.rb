require 'guadaloop/client'
require 'guadaloop/stop'

module Guadaloop
  class Route < Client
    attr_accessor :agency_id
    attr_accessor :route_id

    class << self
      def initialize_from_hash(hash)
        route = Route::new hash['agency_key'], hash['route_id']
        route.raw = hash
        route
      end
    end

    def initialize(agency_id, route_id)
      @agency_id = agency_id
      @route_id = route_id
      @raw = {}
    end

    def get_stops(direction = '')
      uri = "/api/stops/#{@agency_id}/#{@route_id}/#{direction}"
      Client.request uri do |stop|
        Stop::initialize_from_hash stop
      end
    end
  end
end
