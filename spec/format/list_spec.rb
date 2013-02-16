require 'rspectacular'
require 'pinpoint/format/list'

describe Pinpoint::Format::List do
  let(:format_list_class) { Pinpoint::Format::List }
  let(:format_list)       { format_list_class.new }

  it 'can find formats for a country that it has not already loaded' do
    Pinpoint::Format.should_receive(:lookup_by_country)
                    .with(:us)

    format_list[:us]
  end

  it 'can memoize formats for performance' do
    Pinpoint::Format.should_receive(:lookup_by_country)
                    .once
                    .with(:us)
                    .and_return('format')

    format_list[:us]
    format_list[:us]
  end
end
