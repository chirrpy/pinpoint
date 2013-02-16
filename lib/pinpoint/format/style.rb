require 'pinpoint/format/parser'
require 'active_support/core_ext/string/output_safety'

module Pinpoint
  module Format
    class Style

      ##
      # Public: Processes the style information gleaned from the Pinpoint YAML
      # definition format and generates a Style from it.
      #
      # style - The style information from the Pinpoint YAML definition file.
      #         For example:
      #
      #             (%s, )(%l, )(%p )%z(, %c)
      #
      # Returns a Pinpoint::Format::Style based on the information passed in.
      #
      def self.from_definition_yaml(style_definition)
        style = self.new
        style.send(:structure=, Format::Parser.new(style_definition).parse)
        style
      end

      ##
      # Public: Can take an address-like object and output it in the style
      # specified by the structure.
      #
      # Example
      #
      #   # Assuming address is an address-like object and Style was
      #   # instantiated with '(%s, )(%l, )(%p )%z(, %c)'
      #   output address
      #   # => '123 First Street, Nashville, TN 37033, United States'
      #
      def output(address)
        process(structure, address)
      end

      protected

      ##
      # Protected: Access to the underlying structure of the Style (typically is
      # a result of calling Pinpoint::Format::Parser#parse.
      #
      attr_accessor :structure

      private

      ##
      # Private: Can take a Style structure and assemble a String from data from
      # a context.
      #
      # When finishing with a grouping, if there is no alphanumeric content
      # within a grouping, it will be discarded.
      #
      # Returns a String containing data from the context and String literals
      #
      def process(structure, context)
        processed = "".html_safe

        structure.each_with_object(processed) do |token, result|
          result << case token
                    when Array
                      process(token, context)
                    when Symbol
                      context.public_send(token)
                    when String
                      token.html_safe
                    end
        end

        processed.match(no_alphanumerics) ? "".html_safe : processed
      end

      def no_alphanumerics
        /\A[^A-Za-z0-9]*\z/
      end
    end
  end
end
