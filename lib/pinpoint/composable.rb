require 'pinpoint/model_support'
require 'pinpoint/validations'

module Pinpoint
  module Composable
    def pinpoint(name, options = {})
      options[:field_name] = name

      if options[:validate]
        Pinpoint::Validations.define(self, options)
      end

      Pinpoint::ModelSupport.define_address_accessors(self, options)
    end
  end
end
