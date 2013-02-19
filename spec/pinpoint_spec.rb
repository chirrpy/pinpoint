require 'rspectacular'
require 'pinpoint'

class Pinpointable
  extend Pinpoint::Composable

  attr_accessor :address_name,
                :address_street_and_premises,
                :address_city,
                :address_state_or_province,
                :address_postal_code,
                :address_country

  pinpoint :address
end

describe 'Pinpoint' do
  let(:pinpointable) { Pinpointable.new }

  describe '.pinpoint' do
    it 'creates a method to access the address' do
      pinpointable.respond_to?(:address).should be_true
    end

    it 'creates a method to set the address' do
      pinpointable.respond_to?(:address=).should be_true
    end
  end

  describe '#address' do
    it 'is a Pinpoint::Address' do
      pinpointable.address.should be_a Pinpoint::Address
    end

    context 'when the object has address information set' do
      before do
        pinpointable.address_name                 = 'The TARDIS'
        pinpointable.address_street_and_premises  = '413 Citadel Drive'
        pinpointable.address_city                 = 'Panopticon'
        pinpointable.address_state_or_province    = 'Eye of Harmony'
        pinpointable.address_postal_code          = '12345'
      end

      it 'has the correct address components' do
        pinpointable.address.name.should      eql 'The TARDIS'
        pinpointable.address.street.should    eql '413 Citadel Drive'
        pinpointable.address.city.should      eql 'Panopticon'
        pinpointable.address.state.should     eql 'Eye of Harmony'
        pinpointable.address.county.should    eql ''
        pinpointable.address.zip_code.should  eql '12345'
        pinpointable.address.latitude.should  eql ''
        pinpointable.address.longitude.should eql ''
      end
    end
  end

  describe '#address=' do
    context 'when the object has address information set' do
      before do
        pinpointable.address_name                 = 'The TARDIS'
        pinpointable.address_street_and_premises  = '413 Citadel Drive'
        pinpointable.address_city                 = 'Panopticon'
        pinpointable.address_state_or_province    = 'Eye of Harmony'
        pinpointable.address_postal_code          = '12345'
      end

      it 'overrides the current address information with that stored in the Pinpoint::Address' do
        pinpointable.address = Pinpoint::Address.new(
          name:       'Buckingham Palace',
          street:     '',
          city:       'City of Westminster',
          state:      'London',
          zip_code:   'SW1A',
          country:    'United Kingdom'
        )

        pinpointable.address_name.should                eql        'Buckingham Palace'
        pinpointable.address_street_and_premises.should eql        ''
        pinpointable.address_city.should                eql        'City of Westminster'
        pinpointable.address_state_or_province.should   eql        'London'
        pinpointable.address_postal_code.should         eql        'SW1A'
        pinpointable.address_country.should             eql        'United Kingdom'
      end
    end
  end
end
