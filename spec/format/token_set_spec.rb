require 'rspectacular'
require 'pinpoint/format/token_set'

describe Pinpoint::Format::TokenSet do
  let(:token_set_class)   { Pinpoint::Format::TokenSet }
  let(:token_set)         { token_set_class.new }
  let(:group_start_token) { stub(:type => :group_start) }
  let(:group_end_token)   { stub(:type => :group_end) }

  it 'is an Array' do; token_set.should be_an Array; end

  it 'is valid if the number of group pair tokens is equal' do
    token_set = token_set_class.new [group_start_token, group_end_token]

    token_set.should be_valid
  end

  it 'is not valid if the number of group pair tokens is unequal' do
    token_set = token_set_class.new [group_start_token]

    expect { token_set.valid? }.to raise_error Pinpoint::Format::UnevenNestingError
  end
end
