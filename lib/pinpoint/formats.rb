module Pinpoint
  FORMATS = {
    # Zip Code:               5 digits
    #                         Optionally followed by a dash and 4 more digits
    :zip_code                 => /^\d{5}(?:\-\d{4})?$/,
  }
end
