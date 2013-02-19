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
  attr_accessor :my_prefix_name,
                :my_prefix_street_and_premises,
                :my_prefix_city,
                :my_prefix_state,
                :my_prefix_county,
                :my_prefix_postal_code,
                :my_prefix_country,
                :my_prefix_latitude,
                :my_prefix_longitude
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
    let(:pinpointable)       { pinpointable_class.new( my_prefix_name:                 'name',
                                                       my_prefix_street_and_premises:  'street',
                                                       my_prefix_city:                 'city',
                                                       my_prefix_state:                'state',
                                                       my_prefix_county:               'county',
                                                       my_prefix_postal_code:          'postal_code',
                                                       my_prefix_country:              'country',
                                                       my_prefix_latitude:             'latitude',
                                                       my_prefix_longitude:            'longitude' ) }

    it 'can add a reader to a class' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address,
                                                    prefix:     :my_prefix)

      pinpointable.should respond_to :address
    end

    it 'can compose an Address with the proper values from the model' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address,
                                                    prefix:     :my_prefix)

      Pinpoint::Address.should_receive(:new).with(
        my_prefix_name:                 'name',
        my_prefix_street_and_premises:  'street',
        my_prefix_city:                 'city',
        my_prefix_state:                'state',
        my_prefix_county:               'county',
        my_prefix_postal_code:          'postal_code',
        my_prefix_country:              'country',
        my_prefix_latitude:             'latitude',
        my_prefix_longitude:            'longitude'
      )

      pinpointable.address
    end

    it 'can deconstruct an Address into its component pieces' do
      model_support_module.define_address_accessors(pinpointable_class,
                                                    field_name: :address,
                                                    prefix:     :my_prefix)

      address = Pinpoint::Address.new(name:                 'name',
                                      street_and_premises:  'street',
                                      city:                 'city',
                                      state:                'state',
                                      county:               'county',
                                      postal_code:          'postal_code',
                                      country:              'country',
                                      latitude:             'latitude',
                                      longitude:            'longitude')

      pinpointable.should_receive :my_prefix_name=,                 :with => 'name'
      pinpointable.should_receive :my_prefix_street_and_premises=,  :with => 'street'
      pinpointable.should_receive :my_prefix_city=,                 :with => 'city'
      pinpointable.should_receive :my_prefix_state=,                :with => 'state'
      pinpointable.should_receive :my_prefix_county=,               :with => 'county'
      pinpointable.should_receive :my_prefix_postal_code=,          :with => 'postal_code'
      pinpointable.should_receive :my_prefix_country=,              :with => 'country'
      pinpointable.should_receive :my_prefix_latitude=,             :with => 'latitude'
      pinpointable.should_receive :my_prefix_longitude=,            :with => 'longitude'

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
