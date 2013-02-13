require 'pinpoint/format/parse_error'

###
# Public: Has the ability to parse a String for specific token identifiers and
# can process the resulting Tokens using any of the standard Enumerable messages.
#
module Pinpoint
  module Format
    class Tokenizer
      include Enumerable

      ##
      # Public: Initializes a Tokenizer with a given String
      #
      def initialize(string_with_tokens)
        self.tokenable = string_with_tokens
      end

      ##
      # Public: Yields each successive Token to the given block
      #
      def each
        while current_token = next_token
          yield current_token
        end
      end

      ##
      # Public: Alias #to_tokens to #to_a since it is more ideomatic for this
      # class
      #
      alias :to_tokens :to_a

      protected

      # Protected: Reader for tokenable
      attr_reader :tokenable

      ##
      # Protected: Sets tokenable but first checks to see if it needs to be
      # wrapped in an IO object and does so if necessary.
      #
      def tokenable=(value)
        io         = wrap_in_io_if_needed(value)

        @tokenable = StringScanner.new(io.read)
      end

      ##
      # Public: Allows the tokens used for the Tokenizer to be overridden.
      #
      # The value passed must be a Hash with keys representing the title of the
      # token and values containing the Regex which represents a match for that
      # Token.
      #
      # Example
      #
      #   token_map = { ALPHANUMERIC: /[A-Za-z0-9]/
      #
      attr_writer :token_map

      ##
      # Protected: Reads the token_map for the Tokenizer
      #
      # Returns the token_map if it is set, otherwise sets the token_map to the
      # default and returns it.
      #
      def token_map
        @token_map ||= {
          literal:     /[^\(\)%]+/,
          street:      /%s/,
          locality:    /%l/,
          province:    /%p/,
          postal_code: /%z/,
          country:     /%c/,
          percent:     /%%/,
          left_paren:  /%\(/,
          right_paren: /%\)/,
          group_start: /\(/,
          group_end:   /\)/
        }
      end

      private

      ##
      # Private: Checks to see if the value passed in is an IO or something
      # else.  If it's an IO, it remains unmodified, otherwise the value is
      # converted to a StringIO.
      #
      # Example
      #
      #   wrap_in_io_if_needed(my_io_object)
      #   # => my_io_object
      #
      #   wrap_in_io_if_needed('my_string')
      #   # => <StringIO contents: 'my_string'>
      #
      #   wrap_in_io_if_needed(1)
      #   # => <StringIO contents: '1'>
      #
      # Returns an IO object.
      #
      def wrap_in_io_if_needed(value)
        case value
        when IO
          value
        else
          StringIO.new value.to_s
        end
      end

      ##
      # Private: Can locate the next token in the tokenable String
      #
      # Example
      #
      #   # When a Token can be found
      #   next_token
      #   # => [:TOKEN_TITLE, 'my_token']
      #
      #   # When a Token cannot be found
      #   next_token
      #   # => ['a', 'a']
      #
      #   # When there is nothing left to process
      #   next_token
      #   # => false
      #
      # Returns if a Token match can be found, it is an Array containing the
      # title and text for a Token. If the end of the string is reached, it is
      # FalseClass.
      #
      def next_token
        return if tokenable.eos?

        case
        when text = tokenable.scan(token_map[:literal])      then [:literal,      text]
        when text = tokenable.scan(token_map[:street])       then [:street,       text]
        when text = tokenable.scan(token_map[:locality])     then [:locality,     text]
        when text = tokenable.scan(token_map[:province])     then [:province,     text]
        when text = tokenable.scan(token_map[:postal_code])  then [:postal_code,  text]
        when text = tokenable.scan(token_map[:country])      then [:country,      text]
        when text = tokenable.scan(token_map[:percent])      then [:percent,      text]
        when text = tokenable.scan(token_map[:left_paren])   then [:left_paren,   text]
        when text = tokenable.scan(token_map[:right_paren])  then [:right_paren,  text]
        when text = tokenable.scan(token_map[:group_start])  then [:group_start,  text]
        when text = tokenable.scan(token_map[:group_end])    then [:group_end,    text]
        else
          raise ParseError, "Cannot parse the remainder of the tokenable string: '#{tokenable.rest}'"
        end
      end
    end
  end
end
