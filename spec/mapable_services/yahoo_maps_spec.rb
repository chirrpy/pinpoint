require 'rspectacular'
require 'pinpoint/mapable_services/yahoo_maps'

describe Pinpoint::MapableService::YahooMaps do
  it 'can create a YahooMaps URL from the location string' do
    map_url = Pinpoint::MapableService::YahooMaps.map_url(
                location_name: 'name with \\stuff/',
                location:      'location with \\stuff/')

    map_url.should eql(
      'http://maps.yahoo.com#q=' +
      'location+with+%5Cstuff%2F' +
      '&tt=' +
      'name+with+%5Cstuff%2F'
    )
  end
end
