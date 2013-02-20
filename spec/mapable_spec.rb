require 'rspectacular'
require 'pinpoint/mapable'
require 'pinpoint/address'
require 'awesome_print'

class MyMapableClass < Pinpoint::Address
end

describe Pinpoint::Mapable do
  let(:address) { MyMapableClass.new name:                 'name with \\stuff/',
                                     street_and_premises:  'street and premises',
                                     city:                 'city',
                                     state:                'state',
                                     county:               'county',
                                     postal_code:          'postal code',
                                     country:              'country',
                                     latitude:             'latitude',
                                     longitude:            'longitude' }

  context 'when it is mixed in to a Pinpoint::Address-like class' do
    it 'can create a Google Maps URL from the address' do
      address.map_url(:via => :google_maps).should eql 'http://maps.google.com?q=' +
                                                       'street+and+premises%2C+' +
                                                       'city%2C+' +
                                                       'state+' +
                                                       'postal+code%2C+' +
                                                       'country' +
                                                       ' ' +
                                                       '(name+with+%5Cstuff%2F)'
    end
  end
end
