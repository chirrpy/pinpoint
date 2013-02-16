require 'rspectacular'
require 'pinpoint/format/definition'

describe Pinpoint::Format::Definition do
  let(:definition_class) { Pinpoint::Format::Definition }
  let(:definition)       { definition_class.new }

  it 'can lookup a definition by country' do
    Pinpoint::Format::File.should_receive(:styles_for)
                          .and_return 'styles'

    definition = definition_class.lookup_by_country(:us)

    definition.should         be_a definition_class
    definition.styles.should  eql 'styles'
  end

  context 'when it has one or more Styles' do
    let(:style) { stub }

    before      { definition.styles = { :one_line => style } }

    it 'tells the relevant Style to output the address' do
      style.should_receive(:output).with('address').and_return 'formatted_address'

      definition.output('address', :style => :one_line).should eql 'formatted_address'
    end

    it 'defaults output style to one-line' do
      style.should_receive(:output).with('address').and_return 'formatted_address'

      definition.output('address').should eql 'formatted_address'
    end
  end
end
