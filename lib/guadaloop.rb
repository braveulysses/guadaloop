require 'httparty'

require 'guadaloop/agency'
require 'guadaloop/client'
require 'guadaloop/route'
require 'guadaloop/stop'
require 'guadaloop/version'

module Guadaloop
  Northbound = '0'
  Southbound = '1'
  Westbound = '0'
  Eastbound = '1'

  class << self
    def default_agency
      ENV['GTFS_DEFAULT_AGENCY'] || 'capital-metro'
    end

    def get_routes
      agency = Agency::new(Guadaloop::default_agency)
      agency.get_routes()
    end

    def get_stops(route_id, direction)
      route = Route::new(Guadaloop::default_agency, route_id)
      route.get_stops(direction)
    end

    def get_times(route_id, stop_id, direction)
      stop = Stop::new(Guadaloop::default_agency, stop_id)
      stop.get_times(route_id)
    end

    def get_next(route_id, stop_id, direction)
      stop = Stop::new(Guadaloop::default_agency, stop_id)
      stop.get_times(route_id)
      # TODO: Filter out all but next time
    end

    def list_agencies
      Client::request("/api/agencies")
    end

    def get_agencies_near(latitude, longitude, radius=25)
      Client::request("/api/agenciesNearby/#{latitude}/#{longitude}/#{radius}")
    end

    def get_routes_near(latitude, longitude, radius=1)
      Client::request("/api/routesNearby/#{latitude}/#{longitude}/#{radius}")
    end

    def get_stops_near(latitude, longitude, radius=1)
      Client::request("/api/stopsNearby/#{latitude}/#{longitude}/#{radius}")
    end
  end
end
