require 'pinpoint/formatter'
require 'pinpoint/mapable'

module Pinpoint
  class Address
    include Mapable

    ATTRIBUTE_NAMES = [
        :name,
        :street_and_premises,
        :city,
        :state,
        :county,
        :postal_code,
        :country,
        :latitude,
        :longitude
      ]

    attr_accessor *ATTRIBUTE_NAMES

    # City Aliases
    alias :locality       :city
    alias :locality=      :city=

    # Street Aliases
    alias :street         :street_and_premises
    alias :street=        :street_and_premises=

    # State Aliases
    alias :region         :state
    alias :region=        :state=
    alias :province       :state
    alias :province=      :state=

    # Zip Code Aliases
    alias :zip_code       :postal_code
    alias :zip_code=      :postal_code=
    alias :zip            :postal_code
    alias :zip=           :postal_code=

    # County Aliases
    alias :district       :county
    alias :district=      :county=

    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    def complete?
      present?(street_and_premises) &&
      present?(city)                &&
      present?(state)               &&
      present?(postal_code)         &&
      present?(country)
    end

    def incomplete?
      !complete? && !empty?
    end

    def empty?
      blank?(street_and_premises) &&
      blank?(city)                &&
      blank?(state)               &&
      blank?(postal_code)         &&
      blank?(country)
    end

    def to_s(options = { :country => :us, :format => :one_line })
      Formatter.format(self, options)
    end

  private
    def present?(value)
      !blank?(value)
    end

    def blank?(value)
      return true if value.nil?

      if value.respond_to?(:match)
        value.match(/\A\s*\z/)
      else
        false
      end
    end
  end
end
