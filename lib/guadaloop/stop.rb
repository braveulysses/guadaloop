require 'httparty'

require 'guadaloop/client'

module Guadaloop
  class Stop < Client
    attr_accessor :agency_id
    attr_accessor :stop_id

    def initialize(agency_id, stop_id)
      @agency_id = agency_id
      @stop_id = stop_id
    end

    def get_times(route_id, direction = '')
      Client.request "/api/times/#{@agency_id}/#{route_id}/#{@stop_id}/#{direction}"
    end
  end
end
