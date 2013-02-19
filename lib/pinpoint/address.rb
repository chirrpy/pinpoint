require 'pinpoint/formatter'

module Pinpoint
  class Address
    ATTRIBUTE_NAMES = [
        :name,
        :street,
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

    # State Aliases
    alias :region         :state
    alias :region=        :state=
    alias :province       :state
    alias :province=      :state=

    # Zip Code Aliases
    alias :postal_code    :zip_code
    alias :postal_code=   :zip_code=
    alias :postalcode     :zip_code
    alias :postalcode=    :zip_code=
    alias :zip            :zip_code
    alias :zip=           :zip_code=

    # County Aliases
    alias :district       :county
    alias :district=      :county=

    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    def complete?
      present?(street)    &&
      present?(city)      &&
      present?(state)     &&
      present?(zip_code)
    end

    def incomplete?
      !complete? && !empty?
    end

    def empty?
      blank?(street)      &&
      blank?(city)        &&
      blank?(state)       &&
      blank?(zip_code)
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
