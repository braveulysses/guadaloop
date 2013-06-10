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
      r = Client.request "/api/times/#{@agency_id}/#{route_id}/#{@stop_id}/#{direction}"
      r.map { |time| Time.parse(time) if not time.nil? }
    end
  end
end
