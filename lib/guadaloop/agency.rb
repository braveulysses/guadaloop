require 'guadaloop/client'

module Guadaloop
  class Agency < Client
    attr_accessor :agency_id

    class << self
      def initialize_from_hash(hash)
        agency = Agency::new hash['agency_key']
        agency.raw = hash
        agency
      end
    end

    def initialize(agency_id)
      @agency_id = agency_id
    end

    def get_routes()
      Client.request "/api/routes/#{@agency_id}/"
    end
  end
end
