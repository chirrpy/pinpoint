require 'pinpoint/format/tokenizer'

###
# Private: Parses a set of Tokens into a parse tree that can be navigated by
# a Style to render some output.
#
module Pinpoint
  class Format
    class Parser

      ##
      # Public: Initializes a Parser and converts the passed String into
      # a TokenSet that will be utilized when it is parsed.
      #
      # Raises a ParseError if the Tokenizer cannot tokenize the String
      # Returns a Parser
      #
      def initialize(string)
        self.tokens = Pinpoint::Format::Tokenizer.new(string).to_token_set
      end

      ##
      # Public: Provides a way to convert a TokenSet into a tree repersenting
      # groups, message names, and String literals.
      #
      # If the TokenSet is not valid, a form of ParseError is raised.
      #
      # Example
      #
      #   Parser.new('(%s, )((%l, )(%p )%z)(, %c)').parse
      #   # =>  [
      #   #       [
      #   #         :street,
      #   #         ', ',
      #   #       ],
      #   #       [
      #   #         [
      #   #           :locality,
      #   #           ', '
      #   #         ],
      #   #         [
      #   #           :province,
      #   #           ' '
      #   #         ],
      #   #         :postal_code
      #   #       ],
      #   #       [
      #   #         ', ',
      #   #         :country
      #   #       ]
      #   #     ]
      #
      # Returns an Array containing the parse tree structure
      #
      def parse
        process(tokens) if tokens.valid?
      end

      protected

      ##
      # Protected: Reads the TokenSet associated with the Parser
      #
      attr_accessor :tokens

      ##
      # Protected: Can recursively process the TokenSet into an Array containing
      # the parse tree.
      #
      # See also Parser#parse
      #
      # Returns an Array containing the parse tree structure
      #
      def process(token_set)
        result = []

        token_set.process_each! do |token|
          case token.processed_value
          when :group_start
            token_set, intermediate_result = process(token_set)

            result << intermediate_result
          when :group_end
            return [token_set, result]
          else
            result << token.processed_value
          end
        end

        result
      end
    end
  end
end
