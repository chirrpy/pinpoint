require 'rspectacular'
require 'pinpoint/mapable'

class MyMapableClass
  include Pinpoint::Mapable
end

describe Pinpoint::Mapable do
  let(:mapable) { MyMapableClass.new }

  it 'can locate the map URL for itself via a given service' do
    Pinpoint::MapableService::GoogleMaps.should_receive(:map_url)
                                        .with(location_name: 'my_name',
                                              location:      'my_location')
                                        .and_return('map_url')

    mapable.should_receive(:to_s).and_return 'my_location'
    mapable.should_receive(:name).and_return 'my_name'

    mapable.map_url(:via => :google_maps)
  end
end
