require 'pinpoint/us_states'
require 'pinpoint/formats'

module Pinpoint
  module Validations
    def install_validations(name)
      instance_eval <<-VALIDATIONIZATION
        validates :#{name}_name,
                  :length         => {
                    :maximum      => 140 }

        validates :#{name}_street_and_premises,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :length         => {
                    :maximum      => 255 }

        validates :#{name}_city,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :length         => {
                    :maximum      => 60 }

        validates :#{name}_state_or_province,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :inclusion      => {
                    :in           => Pinpoint::US_STATES,
                    :allow_blank  => true }

        validates :#{name}_postal_code,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :format         => {
                    :with         => Pinpoint::FORMATS[:zip_code],
                    :allow_blank  => true }
      VALIDATIONIZATION
    end
  end
end
