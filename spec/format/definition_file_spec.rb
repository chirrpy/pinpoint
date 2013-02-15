require 'rspectacular'
require 'pinpoint/format/definition_file'

describe Pinpoint::Format::DefinitionFile do
  let(:definition_file_class) { Pinpoint::Format::DefinitionFile }

  it 'can retrieve Styles for a given country' do
    File.should_receive(:read).and_return <<-DEFINITION_YAML
      one_line: 'foo'
      multi_line: 'bar'
      html: 'baz'
    DEFINITION_YAML

    styles = definition_file_class.styles_for(:us)

    styles.keys.should eql [
      :one_line,
      :multi_line,
      :html
    ]

    styles.values.should be_all { |s| s.class == Pinpoint::Format::Style }
  end
end
