require 'pinpoint/format/parser'

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
      #             (%s, )((%l, )(%p )%z(, %c)
      #
      # Returns a Pinpoint::Format::Style based on the information passed in.
      #
      def self.from_definition_yaml(style_definition)
        style = self.new
        style.send(:structure=, Format::Parser.new(style_definition).parse)
        style
      end
    end
  end
end
