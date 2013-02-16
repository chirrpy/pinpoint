require 'pinpoint/format/file'

module Pinpoint
  class Format
    attr_accessor :styles

    ##
    # Public: Initialize an empty Format with no styles.
    #
    def initialize
      styles = {}
    end

    ##
    # Public: Attempts to find a format for a given country.
    #
    # country - A Symbol representing the lowercased two-character [ISO
    #           3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) country code for
    #           the country you are trying to load a format for.
    #
    # Example
    #
    #   lookup_by_country(:us)
    #   # => <Format styles: {one_line: <Format::Style>, ....}>
    #
    # Returns a Format loaded with all of the styles that it is capable of.
    #
    def self.lookup_by_country(country)
      format = self.new
      format.styles = Pinpoint::Format::File.styles_for(country)
      format
    end

    ##
    # Public: Will output any given address for the country defined in the
    # Format.
    #
    # By default it will output in a 'one-line' style.
    #
    # address - The address that will be formatted (typically
    #           a Pinpoint::Address).
    #
    # options - A Hash of options for the method
    #
    #           :style - The style to be applied to the address output
    #                    (defaults to :one_line).
    #
    # Example
    #
    #   output my_address, :style => :one_line
    #   # => 'Kwik-E-Mart, 123 Apu Lane, Springfield, NW 12345, United States'
    #
    # Returns a String representing the address in the specified style.
    #
    def output(address, options = {})
      requested_style = options.fetch(:style, :one_line).to_sym

      styles[requested_style].output(address)
    end
  end
end
