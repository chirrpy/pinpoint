require 'ostruct'

module Pinpoint
  module Format
    class Token < Struct.new(:type, :value)
    end
  end
end
