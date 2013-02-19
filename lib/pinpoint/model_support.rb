module Pinpoint
  module ModelSupport
    def self.define_address_accessors(object, name)
      define_address_getter(object, name)
      define_address_setter(object, name)
      define_address_predicates(object, name)
    end

    private

    def self.define_address_getter(object, name)
      # TODO: Memoize
      object.send(:define_method, name) do
        Pinpoint::Address.new(
          :name        => respond_to?(:"#{name}_name")                ? send(:"#{name}_name")                 : '',
          :street      => respond_to?(:"#{name}_street_and_premises") ? send(:"#{name}_street_and_premises")  : '',
          :city        => respond_to?(:"#{name}_city")                ? send(:"#{name}_city")                 : '',
          :state       => respond_to?(:"#{name}_state_or_province")   ? send(:"#{name}_state_or_province")    : '',
          :county      => respond_to?(:"#{name}_district_or_county")  ? send(:"#{name}_district_or_county")   : '',
          :postal_code => respond_to?(:"#{name}_postal_code")         ? send(:"#{name}_postal_code")          : '',
          :country     => respond_to?(:"#{name}_country")             ? send(:"#{name}_country")              : '',
          :latitude    => respond_to?(:"#{name}_latitude")            ? send(:"#{name}_latitude")             : '',
          :longitude   => respond_to?(:"#{name}_longitude")           ? send(:"#{name}_longitude")            : ''
        )
      end
    end

    def self.define_address_setter(object, name)
      object.send(:define_method, "#{name}=") do |address|
        send(:"#{name}_name=",                address.name)
        send(:"#{name}_street_and_premises=", address.street)
        send(:"#{name}_city=",                address.city)
        send(:"#{name}_state_or_province=",   address.state)
        send(:"#{name}_postal_code=",         address.zip_code)
        send(:"#{name}_country=",             address.country)
      end
    end

    def self.define_address_predicates(object, name)
      object.send(:define_method, "#{name}_incomplete?") do
        send(:"#{name}").incomplete?
      end
    end
  end
end
