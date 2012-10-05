require 'spec_helper'

class ValidatablePinpointable
  include ActiveModel::Validations
  include Pinpoint

  attr_accessor :address_name,
                :address_street_and_premises,
                :address_city,
                :address_state_or_province,
                :address_postal_code,
                :address_country

  pinpoint :address, :validate => true
end

class UnvalidatablePinpointable
  include ActiveModel::Validations
  include Pinpoint

  attr_accessor :address_name,
                :address_street_and_premises,
                :address_city,
                :address_state_or_province,
                :address_postal_code,
                :address_country

  pinpoint :address
end

describe 'Pinpoint::Validations' do
  context 'when the pinpoint object has validations enabled' do
    subject { ValidatablePinpointable.new }

    describe '#address_name' do
      it { should     have_valid(:address_name).when                    nil, ('*' * 140)           }
      it { should_not have_valid(:address_name).when                    ('*' * 141)                }
    end

    describe '#address_state_or_province' do
      it { should     have_valid(:address_street_and_premises).when     nil, ('*' * 255)           }
      it { should_not have_valid(:address_street_and_premises).when     ('*' * 256)                }
    end

    describe '#address_city' do
      it { should     have_valid(:address_city).when                    nil, ('*' * 60)            }
      it { should_not have_valid(:address_city).when                    ('*' * 61)                 }
    end

    describe '#address_street_and_premises' do
      it { should     have_valid(:address_state_or_province).when       nil, '', 'NY', 'MO'        }
      it { should_not have_valid(:address_state_or_province).when       'WP', 'NI', 'PO'           }
    end

    describe '#address_postal_code' do
      it { should     have_valid(:address_postal_code).when             nil, '', 12345, 12345-1234 }
      it { should_not have_valid(:address_postal_code).when             'asdf', '123456'           }
    end

    context "when the street address is set" do
      before { subject.address_street_and_premises = "foo" }

      it('the city should not be valid when blank')     { should_not have_valid(:address_city).when                  nil, '' }
      it('the state should not be valid when blank')    { should_not have_valid(:address_state_or_province).when     nil, '' }
      it('the zip code should not be valid when blank') { should_not have_valid(:address_postal_code).when           nil, '' }
    end

    context "when the city is set" do
      before { subject.address_city = "foo" }

      it('the street should not be valid when blank')   { should_not have_valid(:address_street_and_premises).when   nil, '' }
      it('the state should not be valid when blank')    { should_not have_valid(:address_state_or_province).when     nil, '' }
      it('the zip code should not be valid when blank') { should_not have_valid(:address_postal_code).when           nil, '' }
    end

    context "when the state is set" do
      before { subject.address_state_or_province= "FO" }

      it('the street should not be valid when blank')   { should_not have_valid(:address_street_and_premises).when   nil, '' }
      it('the city should not be valid when blank')     { should_not have_valid(:address_city).when                  nil, '' }
      it('the zip code should not be valid when blank') { should_not have_valid(:address_postal_code).when           nil, '' }
    end

    context "when the zip is set" do
      before { subject.address_postal_code = "12345" }

      it('the street should not be valid when blank')   { should_not have_valid(:address_street_and_premises).when   nil, '' }
      it('the city should not be valid when blank')     { should_not have_valid(:address_city).when                  nil, '' }
      it('the state should not be valid when blank')    { should_not have_valid(:address_state_or_province).when     nil, '' }
    end
  end

  context 'when the pinpoint object has validations enabled' do
    subject { UnvalidatablePinpointable.new }

    describe '#address_name' do
      it { should     have_valid(:address_name).when                    ('*' * 141)                }
    end

    describe '#address_state_or_province' do
      it { should     have_valid(:address_street_and_premises).when     ('*' * 256)                }
    end

    describe '#address_city' do
      it { should     have_valid(:address_city).when                    ('*' * 61)                 }
    end

    describe '#address_street_and_premises' do
      it { should     have_valid(:address_state_or_province).when       'WP', 'NI', 'PO'           }
    end

    describe '#address_postal_code' do
      it { should     have_valid(:address_postal_code).when             'asdf', '123456'           }
    end

    context "when the street address is set" do
      before { subject.address_street_and_premises = "foo" }

      it('the city should not be valid when blank')     { should have_valid(:address_city).when                  nil, '' }
      it('the state should not be valid when blank')    { should have_valid(:address_state_or_province).when     nil, '' }
      it('the zip code should not be valid when blank') { should have_valid(:address_postal_code).when           nil, '' }
    end

    context "when the city is set" do
      before { subject.address_city = "foo" }

      it('the street should not be valid when blank')   { should have_valid(:address_street_and_premises).when   nil, '' }
      it('the state should not be valid when blank')    { should have_valid(:address_state_or_province).when     nil, '' }
      it('the zip code should not be valid when blank') { should have_valid(:address_postal_code).when           nil, '' }
    end

    context "when the state is set" do
      before { subject.address_state_or_province= "FO" }

      it('the street should not be valid when blank')   { should have_valid(:address_street_and_premises).when   nil, '' }
      it('the city should not be valid when blank')     { should have_valid(:address_city).when                  nil, '' }
      it('the zip code should not be valid when blank') { should have_valid(:address_postal_code).when           nil, '' }
    end

    context "when the zip is set" do
      before { subject.address_postal_code = "12345" }

      it('the street should not be valid when blank')   { should have_valid(:address_street_and_premises).when   nil, '' }
      it('the city should not be valid when blank')     { should have_valid(:address_city).when                  nil, '' }
      it('the state should not be valid when blank')    { should have_valid(:address_state_or_province).when     nil, '' }
    end
  end
end
