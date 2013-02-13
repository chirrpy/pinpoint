require 'pinpoint/format/parse_error'
require 'pinpoint/format/token_set'
require 'pinpoint/format/token'

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
      # Public: From the beginning of the tokenable String, it reads each token
      # and passes it to the block.
      #
      # Yields each successive Token to the given block
      #
      # Raises subclasses of Pinpoint::Format::ParseError upon various syntax
      #   errors
      #
      # Returns nothing
      #
      def each
        self.tokenable.reset

        while current_token = next_token
          yield current_token
        end
      end

      ##
      # Public: Wraps the Array of Tokens in a TokenSet
      #
      # Returns a TokenSet
      #
      def to_token_set
        TokenSet.new(self.to_a)
      end

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
      #   token_map = { alphanumeric: /[A-Za-z0-9]/
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
      #   # => <Token type: :token_type, value: 'my_token'>
      #
      #   # When a Token cannot be found
      #   next_token
      #   # => Pinpoint::Format::ParseError
      #
      #   # When there is nothing left to process
      #   next_token
      #   # => false
      #
      # Returns a Token if a match is found
      # Returns FalseClass if there is nothing left to process
      # Raises Pinpoint::Format::ParseError if an unknown Token is encountered
      #
      def next_token
        return if tokenable.eos?

        case
        when text = tokenable.scan(token_map[:literal]);     Token.new(:literal,     text)
        when text = tokenable.scan(token_map[:street]);      Token.new(:street,      text)
        when text = tokenable.scan(token_map[:locality]);    Token.new(:locality,    text)
        when text = tokenable.scan(token_map[:province]);    Token.new(:province,    text)
        when text = tokenable.scan(token_map[:postal_code]); Token.new(:postal_code, text)
        when text = tokenable.scan(token_map[:country]);     Token.new(:country,     text)
        when text = tokenable.scan(token_map[:percent]);     Token.new(:literal,     '%')
        when text = tokenable.scan(token_map[:left_paren]);  Token.new(:literal,     '(')
        when text = tokenable.scan(token_map[:right_paren]); Token.new(:literal,     ')')
        when text = tokenable.scan(token_map[:group_start]); Token.new(:group_start, text)
        when text = tokenable.scan(token_map[:group_end]);   Token.new(:group_end,   text)
        else
          raise ParseError, "Cannot parse the remainder of the tokenable string: '#{tokenable.rest}'"
        end
      end
    end
  end
end
