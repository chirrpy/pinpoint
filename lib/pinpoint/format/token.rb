require 'ostruct'

module Pinpoint
  module Format
    class Token < Struct.new(:type, :value)
      def initialize(*args)
        args[0] = args[0].to_sym

        super
      end

      def processed_value
        case type
        when :group_start
          :group_start
        when :group_end
          :group_end
        when :literal
          value
        else
          message
        end
      end

      def to_ary
        [type, value]
      end

      private

      def message
        type_to_message_map[type]
      end

      def type_to_message_map
        {
          name:        :name,
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
