require 'cgi'

module Pinpoint
  module MapableService
    class YahooMaps

      ##
      # Private: Renders a URL for a given location and location name using the
      # Yahoo Maps mapping service.
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
      #   # => http://maps.yahoo.com#q=London%2C+UK&tt=Capital+of+the+UK
      #
      def self.map_url(options = {})
        escaped_map_location  = CGI.escape options.fetch(:location).to_str
        escaped_location_name = CGI.escape options.fetch(:location_name)

        'http://maps.yahoo.com#q=' +
        escaped_map_location +
        '&tt=' +
        escaped_location_name
      end
    end
  end
end
