<img align="right" width="400" src="http://cache.jezebel.com/assets/images/7/2009/07/custom_1245192016735_wargames_missle_locations.jpg" />

Pinpoint
===============================================================================

_(Un)conventional Address Composition for Ruby (and Rails)_

Supported Rubies
--------------------------------
* MRI Ruby 1.9.2
* MRI Ruby 1.9.3
* JRuby (in 1.9 compat mode)

<br/>
<br/>

Installation
-------------------------------------------------------------------------------

First:

```ruby
gem install pinpoint
```

Then in your script:

```ruby
require 'pinpoint'
```

or in your Gemfile

```ruby
gem 'pinpoint'
```

or from IRB

```ruby
irb -r 'pinpoint'
```

Usage
-------------------------------------------------------------------------------

### Direct ####################################################################

Typically Pinpoint is used by requiring it and using the `Pinpoint::Address`
class directly. Like so:

```ruby
class ThingWithAddress
  attr_accessor :address
end

thing = ThingWithAddress.new
thing.address = Pinpoint::Address.new(:foo => :bar)
```

### Composable ################################################################

However it can also be included in the class when the class already has
accessors for all of the different address attributes to generate a composed
address.

```ruby
class ThingWithAddress
  include Pinpoint::Composable

  attr_accessor :street
  attr_accessor :city
  attr_accessor :state
  attr_accessor :zip_code
  attr_accessor :country

  pinpoint :address
end

thing = ThingWithAddress.new

# Set all address fields on `thing`

thing.address # => Pinpoint::Address
```

#### Field Prefixes

If your class has fields that are prefixed by a string (eg venue_city,
venue_state, etc) you can pass `field_prefix` to the compose class method like
so:

```ruby
class ThingWithAddress
  # attr_accessors like:
  attr_accessor :venue_street
  attr_accessor :venue_city

  pinpoint :venue, :field_prefix => 'venue'
end
```

### Address Formatting ########################################################

Pinpoint has an advanced address formatter which can output an address in
multiple country formats.

```ruby
pinpoint_address.to_s(country:  :us,
                      style:    :one_line)
# => 'Kwik-E-Mart, 123 Apu Lane, Springfield, NW 12345, United States'

pinpoint\_address.to\_s(country:  :ru,
                      style:    :one_line)
# => 'Kwik-E-Mart, ul. Apu Lane d. 123, pos. Springfield, NW obl, 12345, United States'
```

_Note: By default, Pinpoint will format addresses for the country that the
address is located in._

### Retrieving Address Information ############################################

* `:name` - The name of the person or business this address is associated with
* `:location_details` - Free form but typically describes the department, mail
  stop, etc).
* `:street` - The name of the street
* `:street_number` - The number that corresponds to the place that the address
  is associated with.
* `:suite_number` - The number associated with the aparment, office or suite.
* `:zip_code` - The postal code associated with the address
* `:city` - The town/villiage/city associated with the address
* `:state` - The state/department/province associated with the address
* `:country` - The country associated with the address

#### Aliases ####

Some of the above attributes are aliased to some other common names:

* `:name` => `:recipient`
* `:name` => `:building_name`
* `:location_details` => `:mail_stop`
* `:zip_code` => `:postal_code`
* `:city` => `:locality`
* `:state` => `:province`

### Geocoding #################################################################

By default, Pinpoint uses [Geocoder]() to add latitude and longitude information
to addresses.

If a Pinpoint address is composed into your class, you can add a `:latitude` and
`:longitude` attribute to it and it will be set/modified when the address is
changed.

Road Map
--------------------------------

* Advanced parsing support
* SimpleForm inputs

Issues
--------------------------------

If you have problems, please create a [Github issue](https://github.com/chirrpy/pinpoint/issues).

Credits
--------------------------------

![](https://dl.dropbox.com/s/f9s2qd0kmbc8nwl/github_logo.png?dl=1)

pinpoint is maintained by [Chrrpy, LLC](http://chirrpy.com)

The names and logos for Chirrpy are trademarks of Chrrpy, LLC

Contributors
--------------------------------
* [Jeff Felchner](https://github.com/jfelchner)

License
--------------------------------

pinpoint is Copyright &copy; 2012 Chirrpy. It is free software, and may be redistributed under the terms specified in the LICENSE file.
