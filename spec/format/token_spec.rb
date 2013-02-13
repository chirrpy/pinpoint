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
end
