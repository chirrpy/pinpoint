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
      # a TokenList that will be utilized when it is parsed.
      #
      # Raises a ParseError if the Tokenizer cannot tokenize the String
      # Returns a Parser
      #
      def initialize(string)
        self.tokens = Pinpoint::Format::Tokenizer.new(string).to_token_list
      end

      ##
      # Public: Provides a way to convert a TokenList into a tree repersenting
      # groups, message names, and String literals.
      #
      # If the TokenList is not valid, a form of ParseError is raised.
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
      # Protected: Reads the TokenList associated with the Parser
      #
      attr_accessor :tokens

      ##
      # Protected: Can recursively process the TokenList into an Array containing
      # the parse tree.
      #
      # See also Parser#parse
      #
      # Returns an Array containing the parse tree structure
      #
      def process(token_list)
        result = []

        token_list.process_each! do |token|
          case token.processed_value
          when :group_start
            token_list, intermediate_result = process(token_list)

            result << intermediate_result
          when :group_end
            return [token_list, result]
          else
            result << token.processed_value
          end
        end

        result
      end
    end
  end
end
