require 'cgi'

module Pinpoint
  module MapableService
    class GoogleMaps

      ##
      # Private: Renders a URL for a given location and location name using the
      # Google Maps mapping service.
      #
      # The location and location name will be properly escaped.
      #
      # options - A Hash of options used in the method
      #
      #           :location      - A String representing the location to display
      #                            via the map URL
      #           :location_name - A String representing the name of the
      #                            location to be displayed via the map URL
      #
      # Example
      #
      #   map_url location:       'London, UK',
      #           location_name:  'Capital of the UK'
      #   # => http://maps.google.com?q=London%2C+UK+%28Capital+of+the+UK%29
      #
      def self.map_url(options = {})
        escaped_map_location  = CGI.escape options.fetch(:location).to_str
        escaped_location_name = CGI.escape "(#{options.fetch(:location_name)})"

        'http://maps.google.com?q=' +
        escaped_map_location +
        '+' +
        escaped_location_name
      end
    end
  end
end
