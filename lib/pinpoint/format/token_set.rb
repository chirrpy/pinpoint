require 'pinpoint/format/parse_error'

module Pinpoint
  module Format
    class TokenSet < Array

      ##
      # Public: Processes each item in the list by removing it and passing it to
      # the block.
      #
      # At the end of the call, the list will be empty.
      #
      # Yields the Token of the iteration
      #
      # Returns nothing
      #
      def process_each!
        while size > 0 do
          token = delete_at(0)

          yield token
        end
      end

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
        count { |token| token.type == :group_start }
      end

      def group_end_count
        count { |token| token.type == :group_end }
      end
    end
  end
end
