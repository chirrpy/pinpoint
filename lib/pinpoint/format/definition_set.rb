require 'pinpoint/format/definition'

module Pinpoint
  module Format
    class DefinitionSet
      include Enumerable

      ##
      # Public: Initializes a new empty DefinitionSet
      #
      def initialize
        self.definitions = Hash.new
      end

      ##
      # Public: Retrieves a Definition for the given country.
      #
      # If the country's Definition has already been retrieved, it is returned,
      # otherwise it is looked up.
      #
      # country - The two letter ISO_3166-1 code for the country you're looking
      #           up the definition for.
      #
      # Example
      #
      #   [:us]
      #   # => <Definition>
      #
      # Returns a Definition which corresponds to the given country.
      #
      def [](country)
        country = country.to_sym

        get(country) ||
        set(country, Pinpoint::Format::Definition.lookup_by_country(country))
      end

      protected

      attr_accessor :definitions

      private

      def get(country)
        self.definitions[country]
      end

      def set(country, definition)
        self.definitions[country] = definition
      end
    end
  end
end
