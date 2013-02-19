require 'pinpoint/model_support'
require 'pinpoint/validations'

module Pinpoint
  module Composable
    def pinpoint(name, options = {})
      if options[:validate]
        Pinpoint::Validations.define(self, name)
      end

      Pinpoint::ModelSupport.define_address_accessors(self, name)
    end
  end
end
