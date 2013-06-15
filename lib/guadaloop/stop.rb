require 'guadaloop/client'

module Guadaloop
  class Stop < Client
    attr_accessor :agency_id
    attr_accessor :stop_id

    class << self
      def initialize_from_hash(hash)
        stop = Stop::new hash['agency_key'], hash['stop_id']
        stop.raw = hash
        stop
      end
    end

    def initialize(agency_id, stop_id)
      @agency_id = agency_id
      @stop_id = stop_id
      @raw = {}
    end

    def get_times(route_id, direction = '')
      uri = "/api/times/#{@agency_id}/#{route_id}/#{@stop_id}/#{direction}"
      Client.request uri do |time|
        begin
          Time.parse(time) if not time.nil?
        rescue ArgumentError
          # Cap Metro GTFS data may include unparseable times like "24:23"
          m = time.match /(\d{2}):(\d{2}):(\d{2})/
          if m[1] == "24"
            Time.parse("01:#{m[2]}:#{m[3]}") + (24 * 60 * 60)
          end
        end
      end
    end
  end
end
