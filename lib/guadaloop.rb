require 'geocoder'
require 'httparty'
require 'thor'

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
      ENV['GTFS_AGENCY'] || 'capital-metro'
    end

    def get_routes
      agency = Agency::new(Guadaloop::default_agency)
      agency.get_routes()
    end

    def get_stops(route_id, direction)
      route = Route::new(Guadaloop::default_agency, route_id)
      route.get_stops(direction)
    end

    def get_times(route_id, stop_id)
      stop = Stop::new(Guadaloop::default_agency, stop_id)
      stop.get_times(route_id)
    end

    def get_next(route_id, stop_id)
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

  class CLI < Thor
    no_commands {
      class << self
        def get_coordinates(address)
          coords = Geocoder.search(address)
          if coords.size < 1
            raise Thor::Error, "Couldn't locate the given address!"
          end
          return coords[0].latitude, coords[0].longitude
        end
      end
    }

    desc "list-bus-stops ADDRESS", "Lists nearby bus stops"
    def list_bus_stops(address)
      latitude, longitude = CLI::get_coordinates(address)
      stops = Guadaloop::get_stops_near(latitude, longitude, 0.5)
      stops.each do |stop|
        print_wrapped "#{stop['stop_id']}: #{stop['stop_name']}: #{stop['stop_desc']}"
      end
    end

    desc "list-train-stops ADDRESS", "Lists nearby train stops"
    def list_train_stops(address)
      latitude, longitude = CLI::get_coordinates(address)
      nearby_stops = Guadaloop::get_stops_near(latitude, longitude, 3)
      train_stops = nearby_stops.select { |stop| not stop['zone_id'].empty? }
      train_stops.each do |stop|
        print_wrapped "#{stop['stop_id']}: #{stop['stop_name']}: #{stop['stop_desc']}"
      end
    end

    desc "list-stops-by-route ROUTE_ID DIRECTION", "Lists stops for a route"
    def list_stops_by_route(route_id, direction)
      stops = Guadaloop::get_stops(route_id, direction)
      stops.each do |stop|
        next if stop.nil?
        print_wrapped "#{stop['stop_id']}: #{stop['stop_name']}: #{stop['stop_desc']}"
      end
    end

    desc "list-times ROUTE_ID STOP_ID", "Lists arrival times for a stop"
    def list_times(route_id, stop_id)
      times = Guadaloop::get_times(route_id, stop_id)
      say times, :magenta
    end

    desc "list-nearby-times ADDRESS DIRECTION RADIUS", "Lists nearby routes and stops"
    def list_nearby_times(address, direction, radius=0.5)
      latitude, longitude = CLI::get_coordinates(address)
      nearby_stops = Guadaloop::get_stops_near(latitude, longitude, radius)
      nearby_routes = Guadaloop::get_routes_near(latitude, longitude, radius)
      nearby_routes.each do |route|
        s = Guadaloop::get_stops(route['route_id'], direction)
        stops_for_route = s.collect { |stop| stop['stop_id'] if not stop.nil? }
        nearby_stops.each do |nearby_stop|
          if stops_for_route.include? nearby_stop['stop_id']
            times = Guadaloop::get_times(route['route_id'], nearby_stop['stop_id'])
            next if times.kind_of? Hash and times.has_key? "error"
            say "Route: #{route['route_short_name']} #{route['route_long_name']}, Stop: #{nearby_stop['stop_name']}"
            say times
          end
        end
      end
    end

    desc "next-bus DIRECTION STOP_ID", "Displays the next bus arrival time"
    def next_bus(direction, stop_id)
      say "this does nothing", :green
    end

    desc "next-train DIRECTION STOP_ID", "Displays the next train arrival time"
    def next_train(direction, stop_id)
      say "this does nothing", :green
    end
  end
end
