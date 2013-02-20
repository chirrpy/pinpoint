require 'pinpoint/model_support'
require 'pinpoint/validations'

module Pinpoint
  module Composable
    ##
    # Public: Allows fields on a class to be composed/decomposed to
    # Pinpoint::Addresses.
    #
    # field_name - The object to apply the accessors to
    # options    - A Hash of options to apply to the method call
    #
    #           :validate   - A Boolean describing whether to include
    #                         ActiveModel::Validations into the class for the
    #                         address fields.
    #           :prefix     - If set, then all fields which make up the Address
    #                         will be prefixed with that string (eg: #venue_city
    #                         instead of just #city) If you do not want field
    #                         names to be prefixed simply set it to false.
    #                         (defaults to the field name).
    #
    # Example
    #
    #   # Implicit Prefix (will look for fields such as 'address_city')
    #   pinpoint :address
    #
    #   # Explicit Prefix (will look for fields such as 'venue_city')
    #   pinpoint :location, :prefix => :venue
    #
    #   # No Prefix (will look for fields such as 'city')
    #   pinpoint :location, :prefix => false
    #
    #   # Include field validations
    #   pinpoint :address, :validate => true
    #
    # Returns nothing
    #
    def pinpoint(field_name, options = {})
      options[:field_name] = field_name

      if options[:validate]
        Pinpoint::Validations.define(self, options)
      end

      Pinpoint::ModelSupport.define_address_accessors(self, options)
    end
  end
end
