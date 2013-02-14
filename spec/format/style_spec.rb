require 'rspectacular'
require 'pinpoint/format/style'
require 'awesome_print'

describe Pinpoint::Format::Style do
  let(:style_class) { Pinpoint::Format::Style }

  it 'can instantiate itself based on a style definition' do
    style_definition = '((%s, )(%l, ))(%p )%z(, %c)'

    style = style_class.from_definition_yaml style_definition

    style.send(:structure).first.first.should eql [:street, ', ']
  end
end
