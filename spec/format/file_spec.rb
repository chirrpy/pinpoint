require 'rspectacular'
require 'pinpoint/format/file'

describe Pinpoint::Format::File do
  let(:file_class) { Pinpoint::Format::File }

  it 'can retrieve Styles for a given country' do
    File.should_receive(:read).and_return <<-FORMAT_YAML
      one_line: 'foo'
      multi_line: 'bar'
      html: 'baz'
    FORMAT_YAML

    styles = file_class.styles_for(:us)

    styles.keys.should eql [
      :one_line,
      :multi_line,
      :html
    ]

    styles.values.should be_all { |s| s.class == Pinpoint::Format::Style }
  end
end
