require 'rspectacular'
require 'pinpoint/format'

describe Pinpoint::Format do
  let(:format_class) { Pinpoint::Format }
  let(:format)       { format_class.new }

  it 'can lookup a format by country' do
    Pinpoint::Format::File.should_receive(:styles_for)
                          .and_return 'styles'

    format = format_class.lookup_by_country(:us)

    format.should         be_a format_class
    format.styles.should  eql 'styles'
  end

  context 'when it has one or more Styles' do
    let(:style) { stub }

    before      { format.styles = { :one_line => style } }

    it 'tells the relevant Style to output the address' do
      style.should_receive(:output).with('address').and_return 'formatted_address'

      format.output('address', :style => :one_line).should eql 'formatted_address'
    end

    it 'defaults output style to one-line' do
      style.should_receive(:output).with('address').and_return 'formatted_address'

      format.output('address').should eql 'formatted_address'
    end
  end
end
