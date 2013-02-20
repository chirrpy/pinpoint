require 'rspectacular'
require 'pinpoint/mapable_services/mapquest'

describe Pinpoint::MapableService::Mapquest do
  it 'can create a Mapquest URL from the location string' do
    map_url = Pinpoint::MapableService::Mapquest.map_url(
                location_name: 'name with \\stuff/',
                location:      'location with \\stuff/')

    map_url.should eql(
      'http://mapquest.com?q=' +
      'location+with+%5Cstuff%2F' +
      '+' +
      '%28name+with+%5Cstuff%2F%29'
    )
  end
end
