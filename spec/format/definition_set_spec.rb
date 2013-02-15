require 'rspectacular'
require 'pinpoint/format/definition_set'

describe Pinpoint::Format::DefinitionSet do
  let(:definition_set_class) { Pinpoint::Format::DefinitionSet }
  let(:definition_set)       { definition_set_class.new }

  it 'can find definitions for a country that it has not already loaded' do
    Pinpoint::Format::Definition.should_receive(:lookup_by_country)
                                .with(:us)

    definition_set[:us]
  end

  it 'can memoize definitions for performance' do
    Pinpoint::Format::Definition.should_receive(:lookup_by_country)
                                .once
                                .with(:us)
                                .and_return('definition')

    definition_set[:us]
    definition_set[:us]
  end
end
