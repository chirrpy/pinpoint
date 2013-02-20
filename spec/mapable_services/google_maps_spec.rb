require 'rspectacular'
require 'pinpoint/mapable_services/google_maps'

describe Pinpoint::MapableService::GoogleMaps do
  it 'can create a GoogleMaps URL from the location string' do
    map_url = Pinpoint::MapableService::GoogleMaps.map_url(
                location_name: 'name with \\stuff/',
                location:      'location with \\stuff/')

    map_url.should eql(
      'http://maps.google.com?q=' +
      'location+with+%5Cstuff%2F' +
      '+' +
      '%28name+with+%5Cstuff%2F%29'
    )
  end
end
