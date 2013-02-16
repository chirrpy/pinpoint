require 'pinpoint/format'

module Pinpoint
  class Format
    class DefinitionSet
      include Enumerable

      ##
      # Public: Initializes a new empty DefinitionSet
      #
      def initialize
        self.formats = Hash.new
      end

      ##
      # Public: Retrieves a Format for the given country.
      #
      # If the country's Format has already been retrieved, it is returned,
      # otherwise it is looked up.
      #
      # country - The two letter ISO_3166-1 code for the country you're looking
      #           up the format for.
      #
      # Example
      #
      #   [:us]
      #   # => <Format>
      #
      # Returns a Format which corresponds to the given country.
      #
      def [](country)
        country = country.to_sym

        get(country) ||
        set(country, Pinpoint::Format.lookup_by_country(country))
      end

      protected

      attr_accessor :formats

      private

      def get(country)
        self.formats[country]
      end

      def set(country, format)
        self.formats[country] = format
      end
    end
  end
end
