module Pinpoint
  class Address
    attr_accessor :name,
                  :street,
                  :city,
                  :state,
                  :county,
                  :zip_code,
                  :country,
                  :latitude,
                  :longitude

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
