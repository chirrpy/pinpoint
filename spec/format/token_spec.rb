require 'rspectacular'
require 'pinpoint/format/token'

describe Pinpoint::Format::Token do
  it 'can be instantiated with the proper arguments' do
    token = Pinpoint::Format::Token.new(:foo, 'bar')

    token.type.should   eql :foo
    token.value.should  eql 'bar'
  end

  it 'always has a symbol for a type even if instantiated with something else' do
    token = Pinpoint::Format::Token.new('foo', 'bar')

    token.type.should   eql :foo
    token.value.should  eql 'bar'
  end

  it 'can determine the value that is needed when processing the token' do
    Pinpoint::Format::Token.new(:group_start).processed_value.should    eql :group_start
    Pinpoint::Format::Token.new(:group_end).processed_value.should      eql :group_end
    Pinpoint::Format::Token.new(:literal, 'foo').processed_value.should eql 'foo'
    Pinpoint::Format::Token.new(:street).processed_value.should         eql :street
  end
end
