require 'rspectacular'
require 'pinpoint/format/style'

describe Pinpoint::Format::Style do
  let(:style_class) { Pinpoint::Format::Style }

  it 'can instantiate itself based on a style definition' do
    style_definition = '((%s, )(%l, ))(%p )%z(, %c)'
    style            = style_class.from_definition_yaml style_definition

    style.send(:structure).first.first.should eql [:street, ', ']
  end

  it 'can output an address based on a style' do
    style_definition = '((%s, )(%l, ))(%p )%z(, %c)'
    style            = style_class.from_definition_yaml style_definition
    address          = stub(street:       'a',
                            locality:     'b',
                            province:     'c',
                            postal_code:  'd',
                            country:      'e')

    style.output(address).should eql 'a, b, c d, e'
  end

  it 'understands not to output a grouping without alphanumeric characters' do
    style_definition = '(%s, )'
    style            = style_class.from_definition_yaml style_definition
    address          = stub(street: '')

    style.output(address).should eql ''
  end
end
