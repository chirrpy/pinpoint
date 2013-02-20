require 'active_support/core_ext/object/blank'
require 'pinpoint/address'

module Pinpoint
  module ModelSupport
    ##
    # Private: Defines address accessors for a given object.
    #
    # object  - The object to apply the accessors to
    # options - A Hash of options to apply to the method call
    #
    #           :field_name - The String or Symbol representing the name of the
    #                         field pair to create (eg: #venue and #venue=).
    #           :prefix     - If set, then all fields which make up the Address
    #                         will be prefixed with that string (eg: #venue_city
    #                         instead of just #city) If you do not want field
    #                         names to be prefixed simply set it to false.
    #                         (defaults to the field name).
    #
    # Example
    #
    #   # Without a Prefix
    #   define_address_accessors my_object, field_name: :venue
    #
    #   # With a Prefix
    #   define_address_accessors my_object, field_name: :address,
    #                                       prefix:     :venue
    #
    # Returns nothing
    #
    def self.define_address_accessors(object, options = {})
      field_name                 = options.fetch(:field_name)
      options[:prefix]           = options.fetch(:prefix, field_name)
      options[:address_fields] ||= find_address_fields(object, options)

      define_address_reader(object, options)
      define_address_setter(object, options)
      define_address_predicates(object, options)
    end

    private

    ##
    # Private: Defines the reader for the composed Address field.
    #
    # The defined method will collect all of the disparate pieces of information
    # from the model and create a Pinpoint::Address that represents that
    # information.
    #
    # object  - (See .define_address_accessors object parameter)
    # options - (See .define_address_accessors options parameter)
    #
    # Returns nothing
    #
    def self.define_address_reader(object, options)
      field_name       = options.fetch(:field_name)
      attribute_fields = options.fetch(:address_fields).fetch(:base_fields)
      reader_fields    = options.fetch(:address_fields).fetch(:reader_fields)
      field_pairs      = attribute_fields.zip reader_fields

      # TODO: Memoize
      object.send(:define_method, field_name) do
        address_fields_and_values = field_pairs.map do |field_pair|
                                      [field_pair[0], send(field_pair[1])]
                                    end

        address_fields_and_values = Hash[address_fields_and_values]

        Pinpoint::Address.new(address_fields_and_values)
      end
    end

    ##
    # Private: Defines the writer for the composed Address field.
    #
    # The defined method will read all of the pieces of the address from the
    # Address that is passed in and set that information on the model's address
    # fields.
    #
    # object  - (See .define_address_accessors object parameter)
    # options - (See .define_address_accessors options parameter)
    #
    # Returns nothing
    #
    def self.define_address_setter(object, options)
      name          = options.fetch(:field_name)
      reader_fields = options.fetch(:address_fields).fetch(:base_fields)
      writer_fields = options.fetch(:address_fields).fetch(:writer_fields)
      field_pairs   = reader_fields.zip writer_fields

      object.send(:define_method, "#{name}=") do |address|
        field_pairs.each do |field_pair|
          send(field_pair[1], address.send(field_pair[0]))
        end
      end
    end

    ##
    # Private: Defines a method which checks to see if the composed address
    # field is incomplete.
    #
    # This is used mainly to remove the need to 'reach into' the Address itself.
    #
    # object  - (See .define_address_accessors object parameter)
    # options - (See .define_address_accessors options parameter)
    #
    # Returns nothing
    #
    def self.define_address_predicates(object, options)
      name = options.fetch(:field_name)

      object.send(:define_method, "#{name}_incomplete?") do
        send(:"#{name}").incomplete?
      end
    end

    ##
    # Private: Finds the writer and reader methods that will be used whenever
    # the composed address field is read from or written to.
    #
    # Additionally it maps writer fields back to the field that must be read
    # from on the Address to get the proper value.
    #
    # Returns a Hash of 'base', 'reader' and 'writer' fields.
    #
    def self.find_address_fields(object, options)
      prefix             = options[:prefix].blank? ? '' : "#{options[:prefix]}_"
      address_attrs      = Pinpoint::Address::ATTRIBUTE_NAMES
      reader_field_names = address_attrs.map { |field| :"#{prefix}#{field}" }
      writer_field_names = address_attrs.map { |field| :"#{prefix}#{field}=" }

      reader_fields      = find_existing_methods(object, reader_field_names)
      writer_fields      = find_existing_methods(object, writer_field_names)
      base_fields        = writer_fields.map do |field|
                             field.to_s.
                                   gsub(/\A#{prefix}/, '').
                                   gsub(/=\z/, '').
                                   to_sym
                           end

      {
        base_fields:   base_fields,
        reader_fields: reader_fields,
        writer_fields: writer_fields
      }
    end

    ##
    # Private: Finds the items that are common between the fields being passed
    # in and the public instance methods on the object.
    #
    # Returns an Array of common methods
    #
    def self.find_existing_methods(object, fields)
      fields & object.new.public_methods
    end
  end
end
