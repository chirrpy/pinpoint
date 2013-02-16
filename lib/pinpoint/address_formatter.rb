require 'pinpoint/format/definition_set'

class Pinpoint::AddressFormatter

  ##
  # Public: Is able to process an Address into numerous formats based on the
  # country and style, or a completely custom format.
  #
  # address - An Object that responds to #name, #street, #city, #state, #county,
  #           #country, #zip_code and #country.
  # options - A Hash of options describing how the address should be formatted
  #
  #           :country - Each country displays its addresses in a specific
  #                      format. Pinpoint knows about these. Passing in two
  #                      letter ISO code as a Symbol for a country will use that
  #                      country's format. (defaults to :us)
  #           :style   - Can be a Symbol which relates to any style in the
  #                      format file that is loaded. Default formats are:
  #
  #                        * :one_line
  #                        * :one_line_with_name
  #                        * :multi_line
  #                        * :multi_line_with_name
  #                        * :html
  #
  #                      All but the 'html' style is standard text.
  #
  #                      The :html option wraps each piece of the address as
  #                      well as the entire address in HTML tags to which CSS
  #                      can be applied for either a single-line or multi-line
  #                      layout.
  #
  #                      Additionally :html will append classes to the different
  #                      pieces of the address which correspond to both the
  #                      globally generic name (eg 'locality').
  #
  # Example
  #
  #   format(address, :country => :us, :style => :one_line)
  #   # => 'Kwik-E-Mart, 123 Apu Lane, Springfield, NW 12345, United States'
  #
  #
  #   format(address, :country => :us, :style => :multi_line)
  #   # => 'Kwik-E-Mart
  #   #     123 Apu Lane
  #   #     Springfield, NW 12345
  #   #     United States'
  #
  #
  #   format(address, country:  :us,
  #                   style:    :html)
  #
  #   # => '<address>
  #   #       <span class="section">
  #   #         <span class="name">Kwik-E-Mart</span>
  #   #       </span>
  #   #       <span class="section">
  #   #         <span class="street">123 Apu Lane</span>
  #   #       </span>
  #   #       <span class="section">
  #   #         <span class="city locality">Springfield</span>
  #   #         <span class="state state_or_province">NW</span>
  #   #         <span class="zip_code postal_code">12345</span>
  #   #       </span>
  #   #       <span class="section">
  #   #         <span class="country">United States</span>
  #   #       </span>
  #   #     </address>'
  #
  def self.format(address, options = {})
    country = options.fetch(:country, :us)
    style   = options.fetch(:style,   :one_line)

    format  = formats[country]

    format.output address, :style => style
  end

  private

  def self.formats
    @formats ||= Pinpoint::Format::DefinitionSet.new
  end
end
