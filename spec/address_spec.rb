require 'rspectacular'
require 'pinpoint/address'

describe 'Pinpoint::Address' do
  let(:address) { Pinpoint::Address.new }

  it { address.respond_to?(:region).should        be_true }
  it { address.respond_to?(:region=).should       be_true }
  it { address.respond_to?(:province).should      be_true }
  it { address.respond_to?(:province=).should     be_true }
  it { address.respond_to?(:locality).should      be_true }
  it { address.respond_to?(:locality=).should     be_true }
  it { address.respond_to?(:postal_code).should   be_true }
  it { address.respond_to?(:postal_code=).should  be_true }
  it { address.respond_to?(:zip).should           be_true }
  it { address.respond_to?(:zip=).should          be_true }
  it { address.respond_to?(:district).should      be_true }
  it { address.respond_to?(:district=).should     be_true }

  describe '#new' do
    context 'when it is passed a set of initial values as a Hash' do
      let(:address) do
        Pinpoint::Address.new(
          name:       'The Frist Center for the Visual Arts',
          street:     '919 Broadway',
          city:       'Nashville',
          state:      'Tennessee',
          county:     'Davidson',
          zip_code:   '37203',
          country:    'United States',
          latitude:   '36.15885623029150',
          longitude:  '-86.78226636970851'
        )
      end

      it 'sets its values properly' do
        address.name.should       eql 'The Frist Center for the Visual Arts'
        address.street.should     eql '919 Broadway'
        address.city.should       eql 'Nashville'
        address.state.should      eql 'Tennessee'
        address.county.should     eql 'Davidson'
        address.zip_code.should   eql '37203'
        address.country.should    eql 'United States'
        address.latitude.should   eql '36.15885623029150'
        address.longitude.should  eql '-86.78226636970851'
      end
    end
  end

  describe '#complete?' do
    context 'when any of the main parts of the address are blank' do
      let(:address) do
        Pinpoint::Address.new(
          street:     '',
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is false' do
        address.should_not be_complete
      end
    end

    context 'when any of the main parts of the address are missing' do
      let(:address) do
        Pinpoint::Address.new(
          street:     nil,
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is false' do
        address.should_not be_complete
      end
    end

    context 'when all of the main parts of the address are present' do
      let(:address) do
        Pinpoint::Address.new(
          street:     '919 Broadway',
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is true' do
        address.should be_complete
      end
    end

    context 'when all of the main parts of the address are missing' do
      let(:address) do
        Pinpoint::Address.new(
          street:     nil,
          city:       nil,
          state:      nil,
          zip_code:   nil
        )
      end

      it 'is false' do
        address.should_not be_complete
      end
    end
  end

  describe '#incomplete?' do
    context 'when any of the main parts of the address are blank' do
      let(:address) do
        Pinpoint::Address.new(
          street:     '',
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is true' do
        address.should be_incomplete
      end
    end

    context 'when any of the main parts of the address are missing' do
      let(:address) do
        Pinpoint::Address.new(
          street:     nil,
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is true' do
        address.should be_incomplete
      end
    end

    context 'when all of the main parts of the address are present' do
      let(:address) do
        Pinpoint::Address.new(
          street:     '919 Broadway',
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is false' do
        address.should_not be_incomplete
      end
    end

    context 'when all of the main parts of the address are missing' do
      let(:address) do
        Pinpoint::Address.new(
          street:     nil,
          city:       nil,
          state:      nil,
          zip_code:   nil
        )
      end

      it 'is false' do
        address.should_not be_incomplete
      end
    end
  end

  describe '#empty?' do
    context 'when any of the main parts of the address are blank' do
      let(:address) do
        Pinpoint::Address.new(
          street:     '',
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is false' do
        address.should_not be_empty
      end
    end

    context 'when any of the main parts of the address are missing' do
      let(:address) do
        Pinpoint::Address.new(
          street:     nil,
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is false' do
        address.should_not be_empty
      end
    end

    context 'when all of the main parts of the address are present' do
      let(:address) do
        Pinpoint::Address.new(
          street:     '919 Broadway',
          city:       'Nashville',
          state:      'Tennessee',
          zip_code:   '37203'
        )
      end

      it 'is false' do
        address.should_not be_empty
      end
    end

    context 'when all of the main parts of the address are missing' do
      let(:address) do
        Pinpoint::Address.new(
          street:     nil,
          city:       nil,
          state:      nil,
          zip_code:   nil
        )
      end

      it 'is true' do
        address.should be_empty
      end
    end
  end
end
