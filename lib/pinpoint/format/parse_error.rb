module Pinpoint
  module Format
    class ParseError          < StandardError; end
    class UnevenNestingError  < ParseError; end
  end
end
