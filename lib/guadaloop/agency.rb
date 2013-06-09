require 'httparty'
require 'guadaloop/client'

module Guadaloop
  class Agency < Client
    attr_accessor :agency_id

    def initialize(agency_id)
      @agency_id = agency_id
    end

    def get_routes()
      Client.request "/api/routes/#{@agency_id}/"
    end
  end
end
