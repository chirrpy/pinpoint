module Addressable
  module ClassMethods
    def address(name)
      instance_eval <<-VALIDATIONIZATION
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
                    :in           => US_STATES,
                    :allow_blank  => true }

        validates :#{name}_postal_code,
                  :presence       => {
                    :if           => :#{name}_incomplete? },
                  :format         => {
                    :with         => Chirrpy::FORMATS[:zip_code],
                    :allow_blank  => true }
      VALIDATIONIZATION

      define_method :"#{name}_address?" do
        send(:"#{name}_street_and_premises?") &&
        send(:"#{name}_city?") &&
        send(:"#{name}_state_or_province?") &&
        send(:"#{name}_postal_code?")
      end

      define_method :"#{name}_incomplete?" do
        send(:"#{name}_street_and_premises?") ||
        send(:"#{name}_city?") ||
        send(:"#{name}_state_or_province?") ||
        send(:"#{name}_postal_code?")
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
