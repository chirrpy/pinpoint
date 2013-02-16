require 'rspectacular'
require 'pinpoint/format/token_list'

describe Pinpoint::Format::TokenList do
  let(:token_list_class)  { Pinpoint::Format::TokenList }
  let(:token_list)        { token_list_class.new }
  let(:group_start_token) { stub(:type => :group_start) }
  let(:group_end_token)   { stub(:type => :group_end) }

  it 'is an Array' do; token_list.should be_an Array; end

  it 'is valid if the number of group pair tokens is equal' do
    token_list = token_list_class.new [group_start_token, group_end_token]

    token_list.should be_valid
  end

  it 'is not valid if the number of group pair tokens is unequal' do
    token_list = token_list_class.new [group_start_token]

    expect { token_list.valid? }.to raise_error Pinpoint::Format::UnevenNestingError
  end

  it 'yields each token to the block when processing' do
    result     = ''
    token_list = token_list_class.new [group_start_token, group_end_token]

    token_list.process_each! do |token|
      result << token.type.to_s
    end

    result.should eql 'group_startgroup_end'
  end

  it 'deletes itself as it processes' do
    token_list = token_list_class.new [group_start_token]

    token_list.process_each! do |token|
    end

    token_list.should be_empty
  end
end
