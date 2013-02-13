require 'ostruct'

module Pinpoint
  module Format
    class Token < Struct.new(:type, :value)
      def initialize(*args)
        args[0] = args[0].to_sym

        super
      end

      def message
        type_to_message_map[type]
      end

      def to_ary
        [type, value]
      end

      private

      def type_to_message_map
        {
          street:      :street,
          locality:    :locality,
          province:    :province,
          postal_code: :postal_code,
          country:     :country
        }
      end
    end
  end
end
