require 'rspectacular'
require 'pinpoint/model_support'

class PinpointableAccessorClass
  def initialize(options = {})
    options.each do |key, value|
      send("#{key}=", value)
    end
  end
end

class PinpointableAccessorClassWithNoPrefixedFields < PinpointableAccessorClass
  attr_accessor :name,
                :street_and_premises,
                :city,
                :state,
                :county,
                :postal_code,
                :country,
                :latitude,
                :longitude
end

class PinpointableAccessorClassWithPrefixedFields < PinpointableAccessorClass
  attr_accessor :my_address_name,
                :my_address_street_and_premises,
                :my_address_city,
                :my_address_state,
                :my_address_county,
                :my_address_postal_code,
                :my_address_country,
                :my_address_latitude,
                :my_address_longitude
end

class PinpointableAccessorClassWithIncompleteFields < PinpointableAccessorClass
  attr_accessor :name,
                :street_and_premises,
                :city,
                :state
end

describe Pinpoint::ModelSupport do
  let(:model_support_module) { Pinpoint::ModelSupport }

  context 'when only a composed name is passed in' do
    let(:pinpointable_class) { PinpointableAccessorClassWithNoPrefixedFields }
    let(:pinpointable)       { pinpointable_class.new( name:                 'name',
                                                       street_and_premises:  'street',
                                                       city:                 'city',
                                                       state:                'state',
                                                       county:               'county',
                                                       postal_code:          'postal_code',
                                                       country:              'country',
                                                       latitude:             'latitude',
                                                       longitude:            'longitude' ) }

    it 'can add a reader to a class' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address)

      pinpointable.should respond_to :address
    end

    it 'can compose an Address with the proper values from the model' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address)

      Pinpoint::Address.should_receive(:new).with(
        name:                 'name',
        street_and_premises:  'street',
        city:                 'city',
        state:                'state',
        county:               'county',
        postal_code:          'postal_code',
        country:              'country',
        latitude:             'latitude',
        longitude:            'longitude'
      )

      pinpointable.address
    end

    it 'can deconstruct an Address into its component pieces' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address)

      address = Pinpoint::Address.new(name:                 'name',
                                      street_and_premises:  'street',
                                      city:                 'city',
                                      state:                'state',
                                      county:               'county',
                                      postal_code:          'postal_code',
                                      country:              'country',
                                      latitude:             'latitude',
                                      longitude:            'longitude')

      pinpointable.should_receive :name=,                 :with => 'name'
      pinpointable.should_receive :street_and_premises=,  :with => 'street'
      pinpointable.should_receive :city=,                 :with => 'city'
      pinpointable.should_receive :state=,                :with => 'state'
      pinpointable.should_receive :county=,               :with => 'county'
      pinpointable.should_receive :postal_code=,          :with => 'postal_code'
      pinpointable.should_receive :country=,              :with => 'country'
      pinpointable.should_receive :latitude=,             :with => 'latitude'
      pinpointable.should_receive :longitude=,            :with => 'longitude'

      pinpointable.address = address
    end
  end

  context 'when a composed name is passed in along with a prefix' do
    let(:pinpointable_class) { PinpointableAccessorClassWithPrefixedFields }
    let(:pinpointable)       { pinpointable_class.new( my_address_name:                 'name',
                                                       my_address_street_and_premises:  'street',
                                                       my_address_city:                 'city',
                                                       my_address_state:                'state',
                                                       my_address_county:               'county',
                                                       my_address_postal_code:          'postal_code',
                                                       my_address_country:              'country',
                                                       my_address_latitude:             'latitude',
                                                       my_address_longitude:            'longitude' ) }

    it 'can add a reader to a class' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address,
                                                    prefix:     :my_address)

      pinpointable.should respond_to :address
    end

    it 'can compose an Address with the proper values from the model' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address,
                                                    prefix:     :my_address)

      Pinpoint::Address.should_receive(:new).with(
        my_address_name:                 'name',
        my_address_street_and_premises:  'street',
        my_address_city:                 'city',
        my_address_state:                'state',
        my_address_county:               'county',
        my_address_postal_code:          'postal_code',
        my_address_country:              'country',
        my_address_latitude:             'latitude',
        my_address_longitude:            'longitude'
      )

      pinpointable.address
    end

    it 'can deconstruct an Address into its component pieces' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address,
                                                    prefix:     :my_address)

      address = Pinpoint::Address.new(name:                 'name',
                                      street_and_premises:  'street',
                                      city:                 'city',
                                      state:                'state',
                                      county:               'county',
                                      postal_code:          'postal_code',
                                      country:              'country',
                                      latitude:             'latitude',
                                      longitude:            'longitude')

      pinpointable.should_receive :my_address_name=,                 :with => 'name'
      pinpointable.should_receive :my_address_street_and_premises=,  :with => 'street'
      pinpointable.should_receive :my_address_city=,                 :with => 'city'
      pinpointable.should_receive :my_address_state=,                :with => 'state'
      pinpointable.should_receive :my_address_county=,               :with => 'county'
      pinpointable.should_receive :my_address_postal_code=,          :with => 'postal_code'
      pinpointable.should_receive :my_address_country=,              :with => 'country'
      pinpointable.should_receive :my_address_latitude=,             :with => 'latitude'
      pinpointable.should_receive :my_address_longitude=,            :with => 'longitude'

      pinpointable.address = address
    end
  end

  context 'when an object is referenced which does not implement all of the fields' do
    let(:pinpointable_class) { PinpointableAccessorClassWithIncompleteFields }
    let(:pinpointable)       { pinpointable_class.new( name:                 'name',
                                                       street_and_premises:  'street',
                                                       city:                 'city',
                                                       state:                'state' ) }

    it 'can compose an Address with the proper values from the model' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name:   :address)

      Pinpoint::Address.should_receive(:new).with(
        name:                 'name',
        street_and_premises:  'street',
        city:                 'city',
        state:                'state'
      )

      pinpointable.address
    end

    it 'can deconstruct an Address into its component pieces' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address)

      address = Pinpoint::Address.new(name:                 'name',
                                      street_and_premises:  'street',
                                      city:                 'city',
                                      state:                'state',
                                      county:               'county',
                                      postal_code:          'postal_code',
                                      country:              'country',
                                      latitude:             'latitude',
                                      longitude:            'longitude')

      pinpointable.should_receive :name=,                 :with => 'name'
      pinpointable.should_receive :street_and_premises=,  :with => 'street'
      pinpointable.should_receive :city=,                 :with => 'city'
      pinpointable.should_receive :state=,                :with => 'state'

      pinpointable.address = address
    end
  end

  context 'when a composed name is not passed in' do
    it 'throws an error' do
      expect { model_support_module.define_address_accessors(pinpointable_class) }.to(
        raise_error)
    end
  end
end
