require 'ostruct'

module Pinpoint
  module Format
    class Token < Struct.new(:type, :value)
      def initialize(*args)
        args[0] = args[0].to_sym

        super
      end
    end
  end
end
