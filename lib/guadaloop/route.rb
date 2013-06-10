require 'guadaloop/client'

module Guadaloop
  class Route < Client
    attr_accessor :agency_id
    attr_accessor :route_id

    def initialize(agency_id, route_id)
      @agency_id = agency_id
      @route_id = route_id
    end

    def get_stops(direction = '')
      Client.request "/api/stops/#{@agency_id}/#{@route_id}/#{direction}"
    end
  end
end
