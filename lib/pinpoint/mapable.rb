require 'active_support/core_ext/string/inflections'
require 'pinpoint/mapable_services/google_maps'
require 'pinpoint/mapable_services/yahoo_maps'
require 'pinpoint/mapable_services/mapquest'

module Pinpoint
  module Mapable

    ##
    # Public: Creates a URL which can be used to locate the Mapable on a map
    # using one of the supported services:
    #
    # * Google Maps
    # * Yahoo Maps
    # * Mapquest
    #
    # options - A Hash of options which will apply to the map URL
    #
    #           :via - A Symbol representing the service to use to create the
    #                  map URL. Options include:
    #
    #                  * :google_maps
    #                  * :yahoo_maps
    #                  * :mapquest
    #
    #                 (defaults to google_maps)
    #
    # Returns a String representing the URL which will display the location in
    #   the browser.
    #
    def map_url(options = {})
      service              = options.fetch(:via, :google_maps)
      service_class        = service_class_for(service)

      service_class.map_url location:       self.to_s,
                            location_name:  self.name
    end

    private

    ##
    # Private: Finds the class name of the service that will be used to resolve
    # the map URL in #map_url.
    #
    # service - A Symbol or String representing the service to be looked up
    #
    # Example
    #
    #   service_class_for :google_maps
    #   # => <Class Pinpoint::MapableService::GoogleMaps>
    #
    def service_class_for(service)
      "Pinpoint::MapableService::#{service.to_s.camelize}".constantize
    end
  end
end
