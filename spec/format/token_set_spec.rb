require 'rspectacular'
require 'pinpoint/format/token_set'

describe Pinpoint::Format::TokenSet do
  let(:token_set_class) { Pinpoint::Format::TokenSet }
  let(:token_set)       { token_set_class.new }

  it 'is an Array' do; token_set.should be_an Array; end

  it 'is valid if the number of group pair tokens is equal' do
    token_set = token_set_class.new [[:group_start], [:group_end]]

    token_set.should be_valid
  end

  it 'is not valid if the number of group pair tokens is unequal' do
    token_set = token_set_class.new [[:group_start]]

    expect { token_set.valid? }.to raise_error Pinpoint::Format::UnevenNestingError
  end
end
