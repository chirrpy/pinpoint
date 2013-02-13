require 'rspectacular'
require 'pinpoint/format/token_set'

describe Pinpoint::Format::TokenSet do
  let(:token_set_class) { Pinpoint::Format::TokenSet }
  let(:token_set)       { token_set_class.new }

  it 'is an Array' do; token_set.should be_an Array; end
end
