require 'cgi'

module Pinpoint
  module Mapable
    def map_url(options = {})
      map_address          = self.to_s.to_str
      escaped_map_address  = CGI.escape map_address
      address_name         = self.name
      escaped_address_name = CGI.escape address_name

      %Q{http://maps.google.com?q=#{escaped_map_address} (#{escaped_address_name})}
    end
  end
end
