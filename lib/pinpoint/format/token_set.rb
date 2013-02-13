require 'pinpoint/format/parse_error'

module Pinpoint
  module Format
    class TokenSet < Array
      ##
      # Public: Verifies that the tokens in the list are in good form.
      #
      # Returns TrueClass if the tokens in the list are valid
      # Raises Pinpoint::Format::UnevenNestingError if the number of
      #   'group_start' tokens does not match the number of 'group_end' tokens.
      #
      def valid?
        raise Pinpoint::Format::UnevenNestingError if group_start_count != group_end_count

        true
      end

      private

      def group_start_count
        count { |token| token[0] == :group_start }
      end

      def group_end_count
        count { |token| token[0] == :group_end }
      end
    end
  end
end
