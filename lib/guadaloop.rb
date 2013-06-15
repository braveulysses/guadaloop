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

  TIME_FORMAT = '%I:%M:%S %p'

  class << self
    def default_agency
      ENV['GTFS_AGENCY'] || 'capital-metro'
    end

    def get_routes
      agency = Agency::new(Guadaloop::default_agency)
      agency.get_routes()
    end

    def get_route(route_id)
      agency = Agency::new(Guadaloop::default_agency)
      agency.get_route(route_id)
    end

    def get_stops(route_id, direction)
      route = Route::new(Guadaloop::default_agency, route_id)
      route.get_stops(direction)
    end

    def get_times(route_id, stop_id)
      stop = Stop::new(Guadaloop::default_agency, stop_id)
      stop.get_times(route_id)
    end

    def get_next(route_id, stop_id, max=1)
      stop = Stop::new(Guadaloop::default_agency, stop_id)
      times = stop.get_times(route_id).select do |time|
        time if not time.nil? and time > Time.now
      end
      times.slice(0, max)
    end

    def list_agencies
      Client::request("/api/agencies") do |agency|
        Agency::initialize_from_hash agency
      end
    end

    def get_agencies_near(latitude, longitude, radius=25)
      uri = "/api/agenciesNearby/#{latitude}/#{longitude}/#{radius}"
      Client::request(uri) do |agency|
        Agency::initialize_from_hash agency
      end
    end

    def get_routes_near(latitude, longitude, radius=1)
      uri = "/api/routesNearby/#{latitude}/#{longitude}/#{radius}"
      Client::request(uri) do |route|
        Route::initialize_from_hash route
      end
    end

    def get_stops_near(latitude, longitude, radius=1)
      uri = "/api/stopsNearby/#{latitude}/#{longitude}/#{radius}"
      Client::request(uri) do |stop|
        Stop::initialize_from_hash stop
      end
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
      nearby_stops = Guadaloop::get_stops_near(latitude, longitude, 0.5)
      bus_stops = nearby_stops.select { |stop| stop.zone_id.empty? }
      bus_stops.each do |stop|
        print_wrapped "#{stop.stop_id}: #{stop.stop_name}: #{stop.stop_desc}"
      end
    end

    desc "list-train-stops ADDRESS", "Lists nearby train stops"
    def list_train_stops(address)
      latitude, longitude = CLI::get_coordinates(address)
      nearby_stops = Guadaloop::get_stops_near(latitude, longitude, 3)
      train_stops = nearby_stops.select { |stop| not stop.zone_id.empty? }
      train_stops.each do |stop|
        print_wrapped "#{stop.stop_id}: #{stop.stop_name}: #{stop.stop_desc}"
      end
    end

    desc "list-stops-by-route ROUTE_ID DIRECTION", "Lists stops for a route"
    def list_stops_by_route(route_id, direction)
      stops = Guadaloop::get_stops(route_id, direction)
      stops.each do |stop|
        next if stop.nil?
        print_wrapped "#{stop.stop_id}: #{stop.stop_name}: #{stop.stop_desc}"
      end
    end

    desc "list-times ROUTE_ID STOP_ID", "Lists arrival times for a stop"
    def list_times(route_id, stop_id)
      times = Guadaloop::get_times(route_id, stop_id)
      route = Guadaloop::get_route(route_id)
      stop = route.get_stop(stop_id)
      say "Route #{route.route_short_name} #{route.route_long_name} stops at #{stop.stop_name} at the following times:", :magenta
      times.each { |t| say t.strftime(TIME_FORMAT), :cyan }
    end

    desc "list-nearby-times ADDRESS DIRECTION RADIUS", "Lists nearby routes and stops"
    def list_nearby_times(address, direction, radius=0.5)
      # TODO: Clean up the presentation
      latitude, longitude = CLI::get_coordinates(address)
      nearby_stops = Guadaloop::get_stops_near(latitude, longitude, radius)
      nearby_routes = Guadaloop::get_routes_near(latitude, longitude, radius)
      nearby_routes.each do |route|
        s = Guadaloop::get_stops(route.route_id, direction)
        stops_for_route = s.collect { |stop| stop.stop_id if not stop.nil? }
        nearby_stops.each do |nearby_stop|
          if stops_for_route.include? nearby_stop.stop_id
            times = Guadaloop::get_times(route.route_id, nearby_stop.stop_id)
            next if times.kind_of? Hash and times.has_key? "error"
            say "Route: #{route.route_short_name} #{route.route_long_name}, Stop: #{nearby_stop.stop_name}"
            say times
          end
        end
      end
    end

    desc "next-bus ROUTE_ID STOP_ID", "Displays the next bus arrival time"
    def next_bus(route_id, stop_id)
      next_departures = Guadaloop::get_next(route_id, stop_id)
      if not next_departures.empty?
        say "The next bus leaves at #{next_departures[0].strftime(TIME_FORMAT)}.", :green
      else
        say "There are no more buses today.", :red
      end
    end

    desc "next-train STOP_ID", "Displays the next train arrival time"
    def next_train(stop_id)
      # Austin has one train, and it's the 550 Metro Rail Red Line
      next_departures = Guadaloop::get_next(550, stop_id)
      if not next_departures.empty?
        say "The next train leaves at #{next_departures[0].strftime(TIME_FORMAT)}.", :green
      else
        say "There are no more trains today.", :red
      end
    end
  end
end
