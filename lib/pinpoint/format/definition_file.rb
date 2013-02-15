require 'yaml'
require 'pinpoint/format/style'

module Pinpoint
  module Format
    class DefinitionFile

      ##
      # Public: Loads the definition for the given country from the appropriate
      # YAML file.
      #
      # It then converts the parsed YAML into Pinpoint::Format::Style objects which
      # can be used to style something that quaks like an Address.
      #
      # country - A Symbol representing the lowercased two-character [ISO
      #           3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) country code for
      #           the country you are trying to load a format definition for.
      #
      # Returns a Hash containing symbolized keys for the style names and values
      # containing Styles.
      #
      def self.styles_for(country)
        raw_style_data(country).each_with_object({}) do |style_definition, hash|
          style_name = style_definition[0]
          style      = style_definition[1]

          hash[style_name.to_sym] = Format::Style.from_definition_yaml(style)
        end
      end

      private

      def self.definition_yaml_contents(country)
        relative_path       = "../../definitions/#{country}.yml"
        definition_filename = File.expand_path(relative_path, __FILE__)

        File.read(definition_filename)
      end

      def self.raw_style_data(country)
        YAML::load(definition_yaml_contents(country))
      end
    end
  end
end
