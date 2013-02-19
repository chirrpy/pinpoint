require 'pinpoint/config/us_states'
require 'pinpoint/config/patterns'

module Pinpoint
  module Validations
    def self.define(object, options)
      name   = options.fetch(:field_name)
      prefix = options.fetch(:prefix, '').empty? ? '' : "#{options[:prefix]}_"

      object.instance_eval <<-VALIDATIONIZATION
        validates :#{prefix}name,
                  :length         => {
                    :maximum      => 140 }

        validates :#{prefix}street_and_premises,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :length         => {
                    :maximum      => 255 }

        validates :#{prefix}city,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :length         => {
                    :maximum      => 60 }

        validates :#{prefix}state,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :inclusion      => {
                    :in           => Pinpoint::US_STATES,
                    :allow_blank  => true }

        validates :#{prefix}postal_code,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :format         => {
                    :with         => Pinpoint::FORMATS[:zip_code],
                    :allow_blank  => true }
      VALIDATIONIZATION
    end
  end
end
