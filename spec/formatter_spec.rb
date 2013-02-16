require 'rspectacular'
require 'ostruct'
require 'pinpoint/formatter'


class Address < Struct.new( :name,
                            :street,
                            :locality,
                            :province,
                            :county,
                            :postal_code,
                            :country,
                            :latitude,
                            :longitude)
end

describe Pinpoint::Formatter do
  let(:address) { Address.new 'Kwik-E-Mart',
                              '123 Apu Lane',
                              'Springfield',
                              'NW',
                              'Springfield County',
                              '12345',
                              'United States',
                              '12345',
                              '67890' }

  describe '#format' do
    it 'can format it in one line US format' do
      expected = "Kwik-E-Mart, 123 Apu Lane, Springfield, NW 12345, United States"

      Pinpoint::Formatter.format(address, country: :us,
                                                 style:   :one_line_with_name)
                                .should eql(expected)
    end

    it 'can format it in multiline US format' do
      expected = <<-MULTILINE
Kwik-E-Mart
123 Apu Lane
Springfield, NW 12345
United States
      MULTILINE

      Pinpoint::Formatter.format(address, country: :us,
                                                 style:   :multi_line_with_name)
                                .should eql(expected)
    end

    it 'can format it in HTML in US format' do
      expected = <<-MULTILINE
<address>
  <span class="section">
    <span class="name">Kwik-E-Mart</span>
  </span>
  <span class="section">
    <span class="street">123 Apu Lane</span>
  </span>
  <span class="section">
    <span class="locality">Springfield</span>
    <span class="province">NW</span>
    <span class="postal_code">12345</span>
  </span>
  <span class="section">
    <span class="country">United States</span>
  </span>
</address>
      MULTILINE

      Pinpoint::Formatter.format(address, country: :us,
                                                 style:   :html)
                                .should eql(expected)
    end

    context 'when the address contains unsafe characters' do
      let(:address) { Address.new "<script>alert('Gotcha!');</script>",
                                  '123 Apu Lane',
                                  'Springfield',
                                  'NW',
                                  'Springfield County',
                                  '12345',
                                  'United States',
                                  '12345',
                                  '67890' }

      it 'escapes anything that is unsafe' do
        expected = <<-MULTILINE
<address>
  <span class="section">
    <span class="name">&lt;script&gt;alert(&#x27;Gotcha!&#x27;);&lt;/script&gt;</span>
  </span>
  <span class="section">
    <span class="street">123 Apu Lane</span>
  </span>
  <span class="section">
    <span class="locality">Springfield</span>
    <span class="province">NW</span>
    <span class="postal_code">12345</span>
  </span>
  <span class="section">
    <span class="country">United States</span>
  </span>
</address>
        MULTILINE

        Pinpoint::Formatter.format(address, country: :us,
                                                  style:   :html)
                                  .should eql(expected)
      end
    end
  end
end
